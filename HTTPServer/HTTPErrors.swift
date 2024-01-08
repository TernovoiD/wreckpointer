//
//  HTTPErrorsEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//

import Foundation

public enum HTTPError: Error {
    case serverError(String)
    case clientError(String)
    case informationaResponse(String)
    case redirectionMessage(String)
    case unknownResponse(String)
    case notDecodable(String)
    case unauthorized
    case badURL
}

extension HTTPError {
    public var errorDescription: String {
        switch self {
        case let .serverError(error):
            return "Server error: \(error)"
        case let .clientError(error):
            return "Client error: \(error)"
        case let .informationaResponse(error):
            return "Info response error: \(error)"
        case let .redirectionMessage(error):
            return "Redirection message: \(error)"
        case let .unknownResponse(error):
            return "Unknown response: \(error)"
        case let .notDecodable(error):
            return "Failed to decode data: \(error)."
        case .badURL:
            return "Error: incorrect URL adress."
        case .unauthorized:
            return "Error: User not authorized."
        }
    }
}
