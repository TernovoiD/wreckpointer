//
//  ModeratorViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import Foundation

@MainActor
final class ModeratorViewModel: ObservableObject {
    
    @Published var wrecks: [Wreck] = [ ]
    @Published var user: User?
    @Published var textToSearch: String = ""
    @Published var unapprovedOnly: Bool = false
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    var searchedWrecks: [Wreck] {
        var filteredWrecks = wrecks
        
        if !textToSearch.isEmpty {
            filteredWrecks = wrecks.filter({ $0.hasName.lowercased().contains(textToSearch.lowercased())})
        }
        
        if unapprovedOnly {
            filteredWrecks = wrecks.filter({ !$0.isApproved })
        }
        
        return filteredWrecks
    }
    
    private func showError(withMessage message: String) {
        self.errorMessage = message
        self.error = true
    }
        
    func loadWrecks() async {
        do {
            guard let url = URL(string: ServerURL.wrecks.path) else {
                throw HTTPError.badURL
            }
            let token = HTTPServerToken.shared.get()
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET, loginToken: token)
            let serverWrecks = try JSONCoder.shared.decodeArrayFromData(data: serverData) as [Wreck]
            DispatchQueue.main.async {
                self.wrecks = [ ]
                self.wrecks = serverWrecks
            }
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func update(wreck: Wreck) async {
        do {
            if let uuid = wreck.id,
               let url = URL(string: ServerURL.wreck(uuid).path) {
                let token = HTTPServerToken.shared.get()
                let data = try JSONCoder.shared.encodeItemToData(item: wreck)
                let _ = try await HTTPServer.shared.sendRequest(url: url, data: data, HTTPMethod: .PATCH, loginToken: token)
                await loadWrecks()
            }
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func delete(wreck: Wreck) async {
        do {
            if let uuid = wreck.id,
               let url = URL(string: ServerURL.wreck(uuid).path) {
                let token = HTTPServerToken.shared.get()
                let _ = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .DELETE, loginToken: token)
                await loadWrecks()
            }
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    } 
}

// MARK: - Auth

extension ModeratorViewModel {
    
    func login(email: String, password: String) async {
        do {
            let basicAuth = createBasicAuthorization(login: email, password: password)
            guard let url = URL(string: ServerURL.login.path) else {
                throw HTTPError.badURL
            }
            let tokenData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .POST, basicAuthorization: basicAuth)
            let token = String(decoding: tokenData, as: UTF8.self)
            try HTTPServerToken.shared.save(token)
            await authorize()
        } catch HTTPError.unauthorized {
            showError(withMessage: "Error: Unauthorized")
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func authorize() async {
        do {
            guard let url = URL(string: ServerURL.login.path) else {
                throw HTTPError.badURL
            }
            if let token = HTTPServerToken.shared.get() {
                let userData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET, loginToken: token)
                let user = try JSONCoder.shared.decodeItemFromData(data: userData) as User
                DispatchQueue.main.async {
                    self.user = user
                }
                await loadWrecks()
            } else {
                self.user = nil
            }
        } catch let error{
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.user = nil
            }
        }
    }
    
    func sighOut() {
        do {
            try HTTPServerToken.shared.delete()
            user = nil
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    private func createBasicAuthorization(login: String, password: String) -> String {
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}
