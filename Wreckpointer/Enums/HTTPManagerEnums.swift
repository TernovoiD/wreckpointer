//
//  HTTPManagerEnums.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//

import Foundation

enum MIMEType: String {
    case JSON = "application/json"
}

enum HTTPHeaders: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum HTTPMethods: String {
    case POST, GET, PUT, PATCH, DELETE
}
