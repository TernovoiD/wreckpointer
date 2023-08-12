//
//  HTTPRequestSender.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class HTTPRequestSender {
    
    static let shared = HTTPRequestSender()
    
    private init() { }
    
    func sendRequest(toURL url: URL,
                     withData data: Data? = nil,
                     withHTTPMethod HTTPMethod: String,
                     withloginToken loginToken: String? = nil,
                     withbasicAuthorization basicAuthorization: String? = nil) async throws -> Data {
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
        
        // Add data
        if let data {
            request.httpBody = data
        }
        
        // Add user login and password
        if let basicAuthorization {
            request.addValue("Basic \(basicAuthorization)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        }
        
        // Add user token
        if let loginToken {
            request.addValue("Bearer \(loginToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try verifyResponse(response)
        return data
    }
    
    private func verifyResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        switch httpResponse.statusCode {
        case 100...199:
            throw HTTPError.informationaResponse
        case 200...299:
            return
        case 300...399:
            throw HTTPError.redirectionMessage
        case 401:
            throw HTTPError.notAuthorized
        case 403:
            throw HTTPError.forbidden
        case 404:
            throw HTTPError.notFound
        case 400, 402, 405...499:
            throw HTTPError.clientError
        case 500...599:
            throw HTTPError.serverError
        default:
            throw HTTPError.unknownResponse
        }
    }
}
