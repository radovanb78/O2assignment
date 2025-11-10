//
//  MockNetworkService.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import Foundation

final class MockNetworkService: NetworkServiceProtocol {
    private let responseData: Decodable

    func networkRequest<RequestData: Encodable, ResponseData: Decodable>(
        url: String,
        method: HttpMethod = .get,
        requestData: RequestData
    ) async throws -> ResponseData {
        try await Task.sleep(for: .seconds(2))
        guard let response = responseData as? ResponseData else {
            throw NSError(domain: "InvalidArgumentError", code: 101, userInfo: nil)
        }
        return response
    }

    init(responseData: Decodable) {
        self.responseData = responseData
    }
}
