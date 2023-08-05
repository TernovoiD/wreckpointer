//
//  CollectionsViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import Foundation

class CollectionsViewModel: ObservableObject {
    
    let collectionsService: CollectionsService
    @Published var collections: [Collection] = [ ]
    
    init(collectionsService: CollectionsService) {
        self.collectionsService = collectionsService
    }
    
        // MARK: - Collections
    
    func fetch() async throws {
        let loadedCollections = try await collectionsService.getCollections()
        DispatchQueue.main.async {
            self.collections = loadedCollections
        }
    }
    
    func create(collection: Collection) async throws {
        let createdCollection = try await collectionsService.create(collection: collection)
        DispatchQueue.main.async {
            self.collections.append(createdCollection)
        }
    }
    
    func update(collection: Collection) async throws {
        let updatedCollection = try await collectionsService.update(collection: collection)
        if let index = collections.firstIndex(where: { $0.id == updatedCollection.id }) {
            collections.remove(at: index)
            collections.append(updatedCollection)
        }
    }
    
    func delete(collection: Collection) async throws {
        try await collectionsService.delete(collection: collection)
    }
    
        // MARK: - Blocks
    
    func addBlock(_ block: Block, toCollection collection: Collection) async throws {
        let newBlock = try await collectionsService.addBlock(block, toCollection: collection)
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index].blocks.append(newBlock)
        }
    }
    
    func updateBlock(_ block: Block, inCollection collection: Collection) async throws {
        let updatedBlock = try await collectionsService.updateBlock(block, inCollection: collection)
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            if let blockIndex = collections[index].blocks.firstIndex(where: { $0.id == block.id }) {
                collections[index].blocks.remove(at: blockIndex)
                collections[index].blocks.append(updatedBlock)
            }
        }
    }
    
    func removeBlock(_ block: Block, fromCollection collection: Collection) async throws {
        try await collectionsService.removeBlock(block, fromCollection: collection)
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            if let blockIndex = collections[index].blocks.firstIndex(where: { $0.id == block.id }) {
                collections[index].blocks.remove(at: blockIndex)
            }
        }
    }
}
