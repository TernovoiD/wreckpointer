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
    
    init(authManager: AuthorizationManager, httpManager: HTTPRequestManager, dataCoder: JSONDataCoder) {
        self.authManager = authManager
        self.httpManager = httpManager
        self.dataCoder = dataCoder
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
    
    func register(user: User) async throws {
        let encodedUserData = try dataCoder.encodeItemToData(item: user)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userLogin + "/register") else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedUserData, withHTTPMethod: HTTPMethods.POST.rawValue)
        
        let token = try dataCoder.decodeItemFromData(data: data) as String
        authManager.saveToken(token)
    }
    
    func signIn(withLogin login: String, andPassword password: String) async throws {
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.userLogin) else {
            throw HTTPError.badURL
        }
        let basicAuth = createBasicAuthorization(login: login, password: password)
        let data = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.POST.rawValue, withbasicAuthorization: basicAuth)
        let userToken = String(decoding: data, as: UTF8.self)
        authManager.saveToken(userToken)
    }
    
    func signOut() {
        authManager.deleteToken()
    }
    
    func deleteAccount(forUser user: User) async throws {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user + "/" + (user.id ?? "error")) else {
            throw HTTPError.badURL
        }
        let _ = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: userToken)
        signOut()
    }
    
    func fetchUser() async throws -> User {
        guard let userToken = authManager.getToken() else { throw HTTPError.notAuthorized }
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.user) else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.GET.rawValue, withloginToken: userToken)
        let authenticatedUser = try dataCoder.decodeItemFromData(data: data) as User
        return authenticatedUser
    }
    
    private func createBasicAuthorization(login: String, password: String) -> String {
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}
