//
//  HTTPServer.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 27.12.2023.
//

import Foundation

final class HTTPServer {
    
    static let shared = HTTPServer()
    
    private init() { }
    
    func sendRequest(url: URL,
                    data: Data? = nil,
                    HTTPMethod: HTTPMethods,
                    loginToken: String? = nil,
                    basicAuthorization: String? = nil) async throws -> Data {
         
         // Create request
         var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.rawValue
         request.addValue(MIMETypes.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
         
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
         
         let serverResponse = try await URLSession.shared.data(for: request)
         return try verify(serverResponse: serverResponse)
     }
    
    private func verify(serverResponse: (Data, URLResponse)) throws -> Data {
        let (data, response) = serverResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.notDecodable((String(data: data, encoding: .utf8) ?? "HTTP response not decoded"))
        }
        
        switch httpResponse.statusCode {
        case 100...199:
            throw HTTPError.informationaResponse(decodeError(fromData: data))
        case 200...299:
            return data
        case 300...399:
            throw HTTPError.redirectionMessage(decodeError(fromData: data))
        case 400, 402...499:
            throw HTTPError.clientError(decodeError(fromData: data))
        case 401:
            throw HTTPError.unauthorized
        case 500...599:
            throw HTTPError.serverError(decodeError(fromData: data))
        default:
            throw HTTPError.unknownResponse(decodeError(fromData: data))
        }
    }
    
    private func decodeError(fromData data: Data) -> String {
        let object = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let response = object as? [String: Any],
           let error = response["reason"] as? String {
            return error
        } else {
            let error = String(data: data, encoding: .utf8)
            return error ?? "Unknown error"
        }
    }
}
