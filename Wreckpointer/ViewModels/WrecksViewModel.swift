//
//  WrecksViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.07.2023.
//

import Foundation

class WrecksViewModel: ObservableObject {
    
    let wrecksService: WrecksService
    let coreDataService: CoreDataService
    
    init(wrecksService: WrecksService, coreDataService: CoreDataService) {
        self.wrecksService = wrecksService
        self.coreDataService = coreDataService
    }
    
    func create(_ wreck: Wreck) async throws {
        let createdWreck = try await wrecksService.createWreck(wreck)
        try coreDataService.addWreck(createdWreck)
    }
    
    func update(_ wreck: Wreck) async throws {
        let updatedWreck = try await wrecksService.updateWreck(wreck)
        try coreDataService.addWreck(updatedWreck)
    }
    
    func delete(_ wreck: Wreck) async throws {
        try await wrecksService.deleteWreck(wreck)
        try coreDataService.deleteWreck(wreck: wreck)
    }
}
