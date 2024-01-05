//
//  CoreDataCoder.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.01.2024.
//

import Foundation
import CoreData

class CoreDataCoder {
    
    static let shared = CoreDataCoder()
    
    private init() { }
    
    func decodeWrecks(formEntities entities: [WreckEntity]) throws -> [Wreck] {
        var wrecks: [Wreck] = [ ]
        for entity in entities {
            var encodedWreck = Wreck(id: entity.id,
                                     createdAt: entity.createdAt,
                                     updatedAt: entity.updatedAt,
                                     name: entity.name,
                                     latitude: entity.latitude == 999999 ? nil : Double(exactly: entity.latitude),
                                     longitude: entity.longitude == 999999 ? nil : Double(exactly: entity.longitude),
                                     type: WreckTypes(rawValue: entity.type ?? "unknown"),
                                     cause: WreckCauses(rawValue: entity.cause ?? "unknown"),
                                     approved: entity.approved,
                                     dive: entity.dive,
                                     dateOfLoss: entity.dateOfLoss,
                                     lossOfLive: entity.lossOfLive == 999999 ? nil : Int(exactly: entity.lossOfLive),
                                     displacement: entity.displacement == 999999 ? nil : Int(exactly: entity.displacement),
                                     depth: entity.depth == 999999 ? nil : Int(exactly: entity.depth),
                                     image: entity.image,
                                     history: entity.history)
            wrecks.append(encodedWreck)
        }
        return wrecks
    }
    
    func encode(wreck: Wreck, withContext context: NSManagedObjectContext) throws {
        let newEntity = WreckEntity(context: context)
        newEntity.id = wreck.id
        newEntity.createdAt = wreck.createdAt
        newEntity.updatedAt = wreck.updatedAt
        newEntity.name = wreck.name
        newEntity.latitude = wreck.latitude ?? 999999
        newEntity.longitude = wreck.longitude ?? 999999
        newEntity.image = wreck.image
        newEntity.type = wreck.type?.rawValue
        newEntity.cause = wreck.cause?.rawValue
        newEntity.approved = wreck.approved ?? false
        newEntity.dive = wreck.dive ?? false
        newEntity.dateOfLoss = wreck.dateOfLoss
        newEntity.lossOfLive = Int64(wreck.lossOfLive ?? 999999)
        newEntity.history = wreck.history
        newEntity.displacement = Int64(wreck.displacement ?? 999999)
        newEntity.depth = Int64(wreck.depth ?? 999999)
    }
}
