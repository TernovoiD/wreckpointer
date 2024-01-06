//
//  HomePageViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import Foundation

final class HomePageViewModel: ObservableObject {
    
    @Published var random5Wrecks: [Wreck] = [ ]
    @Published var last3ApprovedWrecks: [Wreck] = [ ]
    @Published var modernHistory6Wrecks: [Wreck] = [ ]
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        self.errorMessage = message
        self.error = true
    }
    
    func loadWrecks() async {
        do {
            guard let url = URL(string: ServerURL.homePageWrecks.path) else {
                throw HTTPError.badURL
            }
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
            let serverHomePageModel = try JSONCoder.shared.decodeItemFromData(data: serverData) as HomePageModel
            
            DispatchQueue.main.async {
                self.random5Wrecks = serverHomePageModel.random5Wrecks
                self.last3ApprovedWrecks = serverHomePageModel.last3ApprovedWrecks
                self.modernHistory6Wrecks = serverHomePageModel.modernHistory6Wrecks
            }
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
}
