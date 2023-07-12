//
//  WrecksCoreDataManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.07.2023.
//

import Foundation
import CoreData

//class WrecksCoreDataManager {
//    
//    let container: NSPersistentContainer
//    
//    init() {
//        container = NSPersistentContainer(name: "WrecksContainer")
//        container.loadPersistentStores { description, error in
//            if let error {
//                print("Error while loading Core Data \(error)")
//            }
//        }
//    }
//    
//    func addWrecks(wrecksData: [Data]) throws {
//        let now = Date()
//        for datum in wrecksData {
//            let wreckEntity = WreckEntity(context: container.viewContext)
//            wreckEntity.data = datum
//            wreckEntity.lastUpdate = now
//        }
//        try saveData()
//    }
//    
//    func deleteWrecks() throws {
//        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
//        let wreckEntities = try container.viewContext.fetch(request)
//        for wreckEntity in wreckEntities {
//            container.viewContext.delete(wreckEntity)
//        }
//        try saveData()
//    }
//    
//    func fetchWrecks() throws -> ([Data], Date) {
//        var updateTimes: [Date] = [ ]
//        var wrecksData: [Data] = [ ]
//        let request = NSFetchRequest<WreckEntity>(entityName: "WreckEntity")
//        let wreckEntities = try container.viewContext.fetch(request)
//        for wreckEntity in wreckEntities {
//            guard let wreckData = wreckEntity.data,
//                  let updateTime = wreckEntity.lastUpdate else { throw HTTPError.notDecodable }
//            wrecksData.append(wreckData)
//            updateTimes.append(updateTime)
//        }
//        let lastUpdateTime = updateTimes.min() ?? Date()
//        return (wrecksData, lastUpdateTime)
//    }
//    
//    private func saveData() throws {
//        try container.viewContext.save()
//    }
//}
