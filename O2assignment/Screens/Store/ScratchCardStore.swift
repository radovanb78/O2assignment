//
//  ScratchCardStore.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import Combine
import Foundation

enum ScratchCardState: Int {
    case unscratched
    case scratched
    case activated
}

@MainActor
final class ScratchCardStore: ObservableObject {
    @Published private(set) var state: ScratchCardState = .unscratched
    @Published private(set) var isActivating: Bool = false
    @Published private(set) var code: String? = nil
    @Published var globalError: AlertData?

    nonisolated private let service: NetworkServiceProtocol
    private let exclusiveMin: String

    init(service: NetworkServiceProtocol, exclusiveMin: String) {
        self.service = service
        self.exclusiveMin = exclusiveMin
    }

    private var codeGenerationTask: Task<String, Error>?

    var canScratch: Bool {
        state == .unscratched && code != nil
    }

    func setScratched() {
        guard canScratch else { return }
        state = .scratched
    }

    var isScratched: Bool {
        state.rawValue >= ScratchCardState.scratched.rawValue
    }

    func generateCode() async throws -> String {
        guard code == nil,
              codeGenerationTask == nil else {
            throw NSError(domain: "CodeGenerationError", code: 100, userInfo: nil)
        }

        codeGenerationTask = Task<String, Error> { [weak self] in
            do {
                let code: String = try await MockNetworkService(responseData: UUID().uuidString).networkRequest(
                    url: "",
                    requestData: EmptyRequestData()
                )
                try Task.checkCancellation()
                return await MainActor.run {
                    self?.code = code
                    return code
                }
            } catch {
                print("Code generation operation was cancelled or failed: \(error)")
                throw error
            }
        }

        return try await codeGenerationTask!.value
    }

    func cancelCodeGeneration() {
        codeGenerationTask?.cancel()
        codeGenerationTask = nil
    }

    func activate() async -> Bool {
        guard state == .scratched, let code else { return false }
        isActivating = true
        do {
            let response: ActivationResponse = try await service.networkRequest(
                url: "https://api.o2.sk/version",
                method: .get,
                requestData: ActivationRequest(code: code)
            )

            try? await Task.sleep(for: .seconds(2))

            let result = response.isHigherVersionNumber(then: exclusiveMin)

            await MainActor.run {
                if result {
                    self.state = .activated
                }
                else {
                    self.globalError = .init(message: "Activation failed. Please try again later.")
                }
                self.isActivating = false
            }

            return result
        } catch {
            return false
        }
    }
}
