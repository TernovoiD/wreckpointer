//
//  HTTPErrorsEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//

import Foundation

enum HTTPError: Error {
    case serverError
    case clientError
    case informationaResponse
    case redirectionMessage
    case unknownResponse
    case badURL
    case badResponse
    case notFound
    case notDecodable
    case notAuthorized
    case forbidden
}
