//
//  WreckpointerData.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.01.2024.
//

import Foundation

final class WreckpointerData: ObservableObject {
    
    @Published var wrecks: [Wreck] = [ ]
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        Task {
            await loadWrecks()
        }
    }
    
    private func showError(withMessage message: String) {
        self.errorMessage = message
        self.error = true
    }
    
    @MainActor
    func loadWrecks() async {
        do {
            guard let url = URL(string: ServerURL.mapWrecks.path) else {
                throw HTTPError.badURL
            }
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
            let serverWrecks = try JSONCoder.shared.decodeArrayFromData(data: serverData) as [Wreck]
            self.wrecks = serverWrecks
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    @MainActor
    func loadWreck(withID wreckID: UUID?) async -> Wreck? {
        do {
            guard let id = wreckID,
                let url = URL(string: ServerURL.wreck(id).path) else {
                throw HTTPError.badURL
            }
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
            return try JSONCoder.shared.decodeItemFromData(data: serverData) as Wreck
        } catch let error {
            showError(withMessage: "Unable to load wreck from the server: \(error.localizedDescription)")
            return nil
        }
    }
    
    @MainActor
    func create(wreck: Wreck) async {
        do {
            if let url = URL(string: ServerURL.wrecks.path) {
                let data = try JSONCoder.shared.encodeItemToData(item: wreck)
                let serverData = try await HTTPServer.shared.sendRequest(url: url, data: data, HTTPMethod: .POST)
                let serverWreck = try JSONCoder.shared.decodeItemFromData(data: serverData) as Wreck
                self.wrecks.append(serverWreck)
            }
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    @MainActor
    func update(wreck: Wreck) async {
        do {
            if let uuid = wreck.id,
               let url = URL(string: ServerURL.wreck(uuid).path) {
                let token = HTTPServerToken.shared.get()
                let data = try JSONCoder.shared.encodeItemToData(item: wreck)
                let _ = try await HTTPServer.shared.sendRequest(url: url, data: data, HTTPMethod: .PATCH, loginToken: token)
                wrecks.removeAll(where: { $0.id == wreck.id })
                self.wrecks.append(wreck)
            }
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    @MainActor
    func delete(wreck: Wreck) async {
        do {
            if let uuid = wreck.id,
               let url = URL(string: ServerURL.wreck(uuid).path) {
                let token = HTTPServerToken.shared.get()
                let _ = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .DELETE, loginToken: token)
                wrecks.removeAll(where: { $0.id == wreck.id })
            }
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
}
