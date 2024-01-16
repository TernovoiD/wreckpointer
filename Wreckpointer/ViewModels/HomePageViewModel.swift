//
//  HomePageViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import Foundation

@MainActor
final class HomePageViewModel: ObservableObject {
    
    @Published var random5Wrecks: [Wreck] = [ ]
    @Published var last3ApprovedWrecks: [Wreck] = [ ]
    @Published var modernHistory6Wrecks: [Wreck] = [ ]
    @Published var loading: Bool = true
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
            guard let url = URL(string: ServerURL.homePageWrecks.path) else {
                throw HTTPError.badURL
            }
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
            let serverHomePageModel = try JSONCoder.shared.decodeItemFromData(data: serverData) as HomePageModel
            
            random5Wrecks = serverHomePageModel.random5Wrecks
            last3ApprovedWrecks = serverHomePageModel.last3ApprovedWrecks
            modernHistory6Wrecks = serverHomePageModel.modernHistory6Wrecks
            loading = false
        } catch let error {
            showError(withMessage: error.localizedDescription)
            loading = false
        }
    }
}
