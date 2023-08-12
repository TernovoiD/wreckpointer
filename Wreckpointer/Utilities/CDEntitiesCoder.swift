//
//  CDEntitiesCoder.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//

import Foundation
import CoreData

class CDEntitiesCoder {
    
    static let shared = CDEntitiesCoder()
    
    private init() { }
    
    func decodeWrecks(formEntities entities: [WreckEntity]) throws -> [Wreck] {
        var wrecks: [Wreck] = [ ]
        for entity in entities {
            var encodedWreck = Wreck(id: entity.id,
                                     cause: entity.cause ?? "unknown",
                                     type: entity.type ?? "unknown",
                                     title: entity.title ?? "unknown",
                                     image: entity.image,
                                     depth: Double(exactly: entity.depth),
                                     approved: entity.approved,
                                     latitude: entity.latitude,
                                     longitude: entity.longitude,
                                     wreckDive: entity.wreckDive,
                                     dateOfLoss: entity.dateOfLoss,
                                     information: entity.information,
                                     createdAt: entity.createdAt,
                                     updatedAt: entity.updatedAt)
            if let data = entity.creator {
                let creator = try JSONDataCoder.shared.decodeItemFromData(data: data) as User
                encodedWreck.creator = creator
            }
            wrecks.append(encodedWreck)
        }
        return wrecks
    }
    
    func encode(wreck: Wreck, withContext context: NSManagedObjectContext) throws {
        let newEntity = WreckEntity(context: context)
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
        if let creator = wreck.creator {
            let data = try JSONDataCoder.shared.encodeItemToData(item: creator)
            newEntity.creator = data
        }
    }
}
