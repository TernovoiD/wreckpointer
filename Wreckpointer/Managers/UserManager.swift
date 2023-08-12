//
//  UserManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    private let http: HTTPRequestSender
    private let coder: JSONDataCoder
    private let token: TokenStorage
    
    private init() {
        self.http = HTTPRequestSender.shared
        self.coder = JSONDataCoder.shared
        self.token = TokenStorage.shared
    }
    
    func changePassword(userPassword: String, newPassword: String, newPasswordConfirm: String) async throws {
        let passChange = User(password: userPassword, newPassword: newPassword, newPasswordConfirm: newPasswordConfirm)
        let passChangeData = try coder.encodeItemToData(item: passChange)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.passwordChange) else { throw HTTPError.badURL }
        let _ = try await http.sendRequest(toURL: url, withData: passChangeData , withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: token.getToken())
    }
    
    func resetPassword(onEmail email: String) async throws {
        let emailData = try coder.encodeItemToData(item: email)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.passwordReset) else { throw HTTPError.badURL }
        let _ = try await http.sendRequest(toURL: url, withData: emailData , withHTTPMethod: HTTPMethods.POST.rawValue)
    }
    
    func register(user: User) async throws {
        let encodedUserData = try coder.encodeItemToData(item: user)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userLogin + "/register") else {
            throw HTTPError.badURL
        }
        let data = try await http.sendRequest(toURL: url, withData: encodedUserData, withHTTPMethod: HTTPMethods.POST.rawValue)
        
        let userToken = String(decoding: data, as: UTF8.self)
//        let userToken = try coder.decodeItemFromData(data: data) as String
//        print(userToken)
        token.saveToken(userToken)
    }
    
    func update(user: User) async throws -> User {
        let encodedUserData = try coder.encodeItemToData(item: user)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user) else {
            throw HTTPError.badURL
        }
        let data = try await http.sendRequest(toURL: url, withData: encodedUserData, withHTTPMethod: HTTPMethods.PATCH.rawValue, withloginToken: token.getToken())
        
        let authenticatedUser = try coder.decodeItemFromData(data: data) as User
        return authenticatedUser
    }
    
    func signIn(withLogin login: String, andPassword password: String) async throws {
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userLogin) else {
            throw HTTPError.badURL
        }
        let basicAuth = createBasicAuthorization(login: login, password: password)
        let data = try await http.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.POST.rawValue, withbasicAuthorization: basicAuth)
        let userToken = String(decoding: data, as: UTF8.self)
        token.saveToken(userToken)
    }
    
    func signOut() {
        token.deleteToken()
    }
    
    func deleteAccount(forUser user: User) async throws {
        let userID = user.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user + "/" + userID) else {
            throw HTTPError.badURL
        }
        let _ = try await http.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: token.getToken())
        signOut()
    }
    
    func fetchUser() async throws -> User {
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user) else {
            throw HTTPError.badURL
        }
        let data = try await http.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.GET.rawValue, withloginToken: token.getToken())
        let authenticatedUser = try coder.decodeItemFromData(data: data) as User
        return authenticatedUser
    }
    
    private func createBasicAuthorization(login: String, password: String) -> String {
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}