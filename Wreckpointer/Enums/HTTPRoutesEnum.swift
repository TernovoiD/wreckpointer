//
//  HTTPRoutesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//

import Foundation

enum BaseRoutes {
    static let baseURL = "http://127.0.0.1:8080/"
//    static let baseURL = "https://7d7c-151-251-99-138.ngrok.io/"

}

enum Endpoints {
    static let user = "api/v1/user"
    static let userLogin = "api/v1/login"
    static let wreck = "api/v1/wreck"
    
    static let passwordChange = "api/v1/user/password"
    static let passwordReset = "api/v1/password-reset"
    
    static let collections = "api/v1/collections"
}
