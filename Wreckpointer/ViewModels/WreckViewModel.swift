//
//  WreckViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import Foundation

final class WreckViewModel: ObservableObject {
    
    @Published var wreck: Wreck?
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        self.errorMessage = message
        self.error = true
    }
    
    func update(wreck: Wreck) {
        self.wreck = wreck
    }
    
    func synchronizeWithServer() async {
        do {
            if let uuid = wreck?.id,
               let url = URL(string: ServerURL.wreck(uuid).path) {
                let wreckData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
                let serverWreck = try JSONCoder.shared.decodeItemFromData(data: wreckData) as Wreck
                
                DispatchQueue.main.async {
                    self.wreck = serverWreck
                }
            } else {
                return
            }
        } catch let error {
            showError(withMessage: "Unable to load wreck from the server: \(error.localizedDescription)")
        }
    }
}
