//
//  ActivationResponse.swift
//  O2_iOS_assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

struct ActivationResponse: Decodable {
    let ios: String

    func isHigherVersionNumber(then other: String) -> Bool {
        let lhsComponents = ios.split(separator: ".").map { Int($0) ?? 0 }
        let rhsComponents = other.split(separator: ".").map { Int($0) ?? 0 }

        let maxLength = max(lhsComponents.count, rhsComponents.count)
        let lhs = lhsComponents + Array(repeating: 0, count: maxLength - lhsComponents.count)
        let rhs = rhsComponents + Array(repeating: 0, count: maxLength - rhsComponents.count)

        for (l, r) in zip(lhs, rhs) {
            if l == r { continue }
            return l > r
        }

        return false
    }
}

