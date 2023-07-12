//
//  UserService.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.07.2023.
//

import Foundation

class UserService {
    
    let authManager: AuthorizationManager
    let httpManager: HTTPRequestManager
    let dataCoder: JSONDataCoder
    var authenticatedUser: User?
    
    init(authManager: AuthorizationManager, httpManager: HTTPRequestManager, dataCoder: JSONDataCoder) {
        self.authManager = authManager
        self.httpManager = httpManager
        self.dataCoder = dataCoder
        self.authenticatedUser = nil
    }
    
    func changePassword(userPassword: String, newPassword: String, newPasswordConfirm: String) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        let passChange = User(password: userPassword, newPassword: newPassword, newPasswordConfirm: newPasswordConfirm)
        let passChangeData = try dataCoder.encodeItemToData(item: passChange)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.passwordChange) else { throw HTTPError.badURL }
        let _ = try await httpManager.sendRequest(toURL: url, withData: passChangeData , withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: userToken)
    }
    
    func resetPassword(onEmail email: String) async throws {
        let emailData = try dataCoder.encodeItemToData(item: email)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.passwordReset) else { throw HTTPError.badURL }
        let _ = try await httpManager.sendRequest(toURL: url, withData: emailData , withHTTPMethod: HTTPMethods.POST.rawValue)
    }
    
    func register(user: User) async throws -> User {
        let encodedUserData = try dataCoder.encodeItemToData(item: user)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userLogin + "/register") else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedUserData, withHTTPMethod: HTTPMethods.POST.rawValue)
        
        let user = try dataCoder.decodeItemFromData(data: data) as User
        return user
    }
    
    func signIn(withLogin login: String, andPassword password: String) async throws {
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userLogin) else {
            throw HTTPError.badURL
        }
        let basicAuth = createBasicAuthorization(login: login, password: password)
        let data = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.POST.rawValue, withbasicAuthorization: basicAuth)
        let userToken = String(decoding: data, as: UTF8.self)
        authManager.saveToken(userToken)
        try await fetchUser()
    }
    
    func signOut() {
        authManager.deleteToken()
        authenticatedUser = nil
    }
    
    func deleteAccount() async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user + "/" + (authenticatedUser?.id ?? "error")) else {
            throw HTTPError.badURL
        }
        let _ = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: userToken)
        signOut()
    }
    
    func fetchUser() async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user) else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.GET.rawValue, withloginToken: userToken)
        authenticatedUser = try dataCoder.decodeItemFromData(data: data) as User
    }
    
    private func createBasicAuthorization(login: String, password: String) -> String {
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}
