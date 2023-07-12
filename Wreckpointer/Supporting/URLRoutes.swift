//
//  URLRoutes.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.07.2023.
//

import Foundation

enum BaseRoutes {
    static let baseURL = "http://127.0.0.1:8080/"

}

enum Endpoints {
    static let user = "api/v1/user"
    static let userLogin = "api/v1/login"
    static let wreck = "api/v1/wreck"
    
    static let passwordChange = "api/v1/user/password"
    static let passwordReset = "api/v1/password-reset"
}
