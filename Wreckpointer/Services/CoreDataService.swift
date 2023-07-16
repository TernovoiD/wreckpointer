//
//  CoreDataService.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.07.2023.
//

import Foundation
import CoreData

class CoreDataService {
    
    let dataCoder: JSONDataCoder
    let container: NSPersistentContainer
    
    init(dataCoder: JSONDataCoder) {
        self.dataCoder = dataCoder
        container = NSPersistentContainer(name: "WreckpointerContainer")
        container.loadPersistentStores { description, error in
            if let error {
                print("Error while loading Core Data \(error)")
            }
        }
    }
    
    func lastUpdateTime() throws -> Date {
        var updateTimes: [Date] = [ ]
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let wreckEntities = try container.viewContext.fetch(request)
        for wreckEntity in wreckEntities {
            updateTimes.append(wreckEntity.createdAt ?? Date())
            updateTimes.append(wreckEntity.updatedAt ?? Date())
        }
        let lastUpdateTime = updateTimes.max() ?? Date()
        return lastUpdateTime
    }
    
    func fetchWrecks() throws -> [Wreck] {
        var wrecks: [Wreck] = [ ]
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let wreckEntities = try container.viewContext.fetch(request)
        for wreckEntity in wreckEntities {
            
            var newWreck = Wreck(id: wreckEntity.id,
                                 cause: wreckEntity.cause ?? "unknown",
                                 type: wreckEntity.type ?? "unknown",
                                 title: wreckEntity.title ?? "unknown",
                                 image: wreckEntity.image,
                                 depth: Double(exactly: wreckEntity.depth),
                                 approved: wreckEntity.approved,
                                 latitude: wreckEntity.latitude,
                                 longitude: wreckEntity.longitude,
                                 wreckDive: wreckEntity.wreckDive,
                                 dateOfLoss: wreckEntity.dateOfLoss,
                                 information: wreckEntity.information,
                                 createdAt: wreckEntity.createdAt,
                                 updatedAt: wreckEntity.updatedAt,
                                 moderators: [])
            
            if let wreckModerators = wreckEntity.moderators {
                let moderators = try dataCoder.decodeItemsArrayFromData(data: wreckModerators) as [User]
                newWreck.moderators = moderators
            }
            wrecks.append(newWreck)
        }
        return wrecks
    }
    
    func addWrecks(_ wrecks: [Wreck]) throws {
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let wreckEntities = try container.viewContext.fetch(request)
        
        for wreck in wrecks {
            if let index = wreckEntities.firstIndex(where: { $0.id == wreck.id }) {
                deleteWreck(wreckEntity: wreckEntities[index])
            }
            try createEntity(forWreck: wreck)
        }
        try saveData()
    }
    
    func addWreck(_ wreck: Wreck) throws {
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let wreckEntities = try container.viewContext.fetch(request)
        
        if let index = wreckEntities.firstIndex(where: { $0.id == wreck.id }) {
            deleteWreck(wreckEntity: wreckEntities[index])
        }
        try createEntity(forWreck: wreck)
        
        try saveData()
    }
    
    func deleteWrecks() throws {
        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
        let wreckEntities = try container.viewContext.fetch(request)
        
        for entity in wreckEntities {
            deleteWreck(wreckEntity: entity)
        }
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
    
    private func deleteWreck(wreckEntity: WreckEntity) {
        container.viewContext.delete(wreckEntity)
    }
    
    private func createEntity(forWreck wreck: Wreck) throws {
        
        let newEntity = WreckEntity(context: container.viewContext)
        newEntity.id = wreck.id
        newEntity.cause = wreck.cause
        newEntity.type = wreck.type
        newEntity.title = wreck.title
        newEntity.image = wreck.image
        newEntity.depth = Int64(exactly: wreck.depth ?? 0) ?? 0
        newEntity.approved = wreck.approved ?? false
        newEntity.latitude = wreck.latitude
        newEntity.longitude = wreck.longitude
        newEntity.wreckDive = wreck.wreckDive
        newEntity.dateOfLoss = wreck.dateOfLoss
        newEntity.information = wreck.information
        newEntity.createdAt = wreck.createdAt
        newEntity.updatedAt = wreck.updatedAt
        
        if let wreckModerators = wreck.moderators {
            let moderatorsData = try dataCoder.encodeItemsToData(items: wreckModerators)
            newEntity.moderators = moderatorsData
        }
    }
    
    private func saveData() throws {
        try container.viewContext.save()
    }
}
