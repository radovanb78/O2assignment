//
//  NetworkServiceProtocol.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct EmptyRequestData: Encodable {}

protocol NetworkServiceProtocol {
    func networkRequest<RequestData: Encodable, ResponseData: Decodable>(
        url: String,
        method: HttpMethod,
        requestData: RequestData
    ) async throws -> ResponseData
}
