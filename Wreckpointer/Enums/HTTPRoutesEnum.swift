//
//  HTTPRoutesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//

import Foundation

enum BaseRoutes {
    static let baseURL = "https://wreckpointer.digital/"
//        static let baseURL = "http://127.0.0.1:8080/"
}

enum Endpoints {
    static let user = "api/v1/user"
    static let wreck = "api/v1/wreck"
    static let userLogin = "api/v1/login"
    static let password = "api/v1/password"
    static let collections = "api/v1/collections"
}
