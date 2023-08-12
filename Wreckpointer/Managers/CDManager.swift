//
//  CDManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation
import CoreData

class CDManager {
    
    static let shared = CDManager()
    
    private let container: NSPersistentContainer
    private let coder: CDEntitiesCoder
    
    private init() {
        self.coder = CDEntitiesCoder.shared
        container = NSPersistentContainer(name: "WreckpointerContainer")
        container.loadPersistentStores { description, error in
            if let error {
                print("Error while loading Core Data \(error)")
            }
        }
    }
    
    func fetchWrecks() throws -> [Wreck] {
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let entities = try container.viewContext.fetch(request)
        return try coder.decodeWrecks(formEntities: entities)
    }
    
    func save(wreck: Wreck) throws {
        try coder.encode(wreck: wreck, withContext: container.viewContext)
        try saveData()
    }
    
    func deleteWreck(wreck: Wreck) throws {
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let wreckEntities = try container.viewContext.fetch(request)
        
        if let index = wreckEntities.firstIndex(where: { $0.id == wreck.id }) {
            deleteWreck(wreckEntity: wreckEntities[index])
        }
        try saveData()
    }
    
    func deleteAll() throws {
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let wreckEntities = try container.viewContext.fetch(request)
        
        for entity in wreckEntities {
            deleteWreck(wreckEntity: entity)
        }
        try saveData()
    }
    
    private func deleteWreck(wreckEntity: WreckEntity) {
        container.viewContext.delete(wreckEntity)
    }
    
    private func saveData() throws {
        try container.viewContext.save()
    }
}
