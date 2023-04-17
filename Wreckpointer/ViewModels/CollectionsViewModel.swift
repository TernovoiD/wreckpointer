//
//  CollectionsViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import SwiftUI

class CollectionsViewModel: ObservableObject {
    
    // Loading status
    @Published var loadingCollections: Bool = true
    @Published var loadingWrecks: Bool = false
    
    // iCloud Authentication
    @Published var permissionStatus: Bool = false
    @Published var iCloudIsSignedIn: Bool = false
    
    // Data
    @Published var allCollections: [WrecksCollection] = []
    @Published var allWrecks: [Wreck] = []
    
    // This field is used to represent Wrecks owned by WrecksCollection
    @Published var collectionWrecks: [Wreck] = []
    
    // Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        fetchCollections()
    }
    
    func showError(withMessage message: String) {
        errorMessage = message
        error = true
    }
}


//MARK: User

extension CollectionsViewModel {
    
    func checkICloudStatus() {
        CKManager.getiCloudStatus { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    self?.iCloudIsSignedIn = status
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func requestUserIdentityPermission() {
        CKManager.requestPermission { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    self?.permissionStatus = status
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
}

//MARK: Collections

extension CollectionsViewModel {
    
    func createCollection(withTitle collectionTitle: String,
                          andDescription collectionDescription: String,
                          andImage collectionImageData: Data?) {
        let imageURL = getImageURL(fromData: collectionImageData)


        guard let newCollection = WrecksCollection(imageURL: imageURL,
                                                   title: collectionTitle,
                                                   description: collectionDescription) else { return }
        
        CKManager.add(item: newCollection) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.allCollections.append(newCollection)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func fetchCollections() {
        let predicate = NSPredicate(value: true)
        
        CKManager.fetch(predicate: predicate, recordType: "WrecksCollection") { [weak self] (items: [WrecksCollection]) in
            DispatchQueue.main.async {
                self?.allCollections = items
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.spring()) {
                        self?.loadingCollections = false
                    }
                }
            }
        }
    }
    
    func updateCollection(newTitle title: String,
                          newDescription description: String,
                          newImage imageData: Data?,
                          collection: WrecksCollection) {
        let imageURL = getImageURL(fromData: imageData)
        guard let updatedCollection = collection.update(newTitle: title, newDescription: description, newImageURL: imageURL) else { return }
        
        CKManager.update(item: updatedCollection) { [weak self] result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async {
                    if let returnedRecord = record {
                        guard let returnedCollection = WrecksCollection(record: returnedRecord) else {
                            self?.showError(withMessage: "Collection not found")
                            return
                        }
                        guard let currentIndex = self?.allCollections.firstIndex(where: { $0.id == returnedCollection.id }) else {
                            self?.showError(withMessage: "Collection not found")
                            return
                        }
                        self?.allCollections[currentIndex] = returnedCollection
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func deleteCollection(collection: WrecksCollection) {
        CKManager.delete(item: collection) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    guard let currentIndex = self?.allCollections.firstIndex(where: { $0 == collection }) else {
                        DispatchQueue.main.async {
                            self?.showError(withMessage: "Collection not found")
                        }
                        return
                    }
                    self?.allCollections.remove(at: currentIndex)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
}

//MARK: Wrecks

extension CollectionsViewModel {
    
    func createWreck(withTitle title: String,
                     andDescription description: String,
                     andDepth depth: Double,
                     andLatitude latitude: Double,
                     andLongitude longitude: Double,
                     andDateOfLoss dateOfLoss: Date,
                     andImageData imageData: Data?,
                     inCollection owningCollection: WrecksCollection) {
        
        let imageURL = getImageURL(fromData: imageData)
        guard let newWreck = Wreck(title: title,
                                   imageURL: imageURL,
                                   depth: depth,
                                   latitude: latitude,
                                   longitude: longitude,
                                   dateOfLoss: dateOfLoss,
                                   description: description) else { return }
        
        CKManager.addWithReference(fromItem: newWreck,
                                   toItem: owningCollection,
                                   withReferenceFieldName: "owningCollection",
                                   withReferenceAction: .deleteSelf) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.collectionWrecks.append(newWreck)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func fetchAllWrecks() {
        let predicate = NSPredicate(value: true)
        CKManager.fetch(predicate: predicate, recordType: "Wreck") { [weak self] (items: [Wreck]) in
            DispatchQueue.main.async {
                self?.allWrecks = items
            }
        }
    }
    
    func fetchWrecks(fromCollection collection: WrecksCollection) {
        
        CKManager.fetchReferences(forItem: collection,
                                  andField: "owningCollection",
                                  recordType: "Wreck") { [weak self] (items: [Wreck]) in
            DispatchQueue.main.async {
                withAnimation(.easeInOut) {
                    self?.collectionWrecks = items
                    self?.loadingWrecks = false
                }
            }
        }
    }
    
    func updateWreck(newTitle title: String,
                     newDescription description: String,
                     newDepth depth: Double,
                     newLatitude latitude: Double,
                     newLongitude longitude: Double,
                     newDateOfLoss dateOfLoss: Date,
                     newImageData imageData: Data?,
                     wreck: Wreck) {
        let newImageURL = getImageURL(fromData: imageData)
        guard let updatedWreck = wreck.update(newTitle: title,
                                              newDescription: description,
                                              newImageURL: newImageURL,
                                              newDepth: depth,
                                              newLatitude: latitude,
                                              newLongitude: longitude,
                                              newDateOfLoss: dateOfLoss) else { return }
        
        CKManager.update(item: updatedWreck) { [weak self] result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async {
                    if let returnedRecord = record {
                        guard let returnedWreck = Wreck(record: returnedRecord) else {
                            self?.showError(withMessage: "Collection not found")
                            return
                        }
                        guard let currentIndex = self?.collectionWrecks.firstIndex(where: { $0.id == returnedWreck.id }) else {
                            self?.showError(withMessage: "Collection not found")
                            return
                        }
                        self?.collectionWrecks[currentIndex] = returnedWreck
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
        
    }
    
    func deleteWreck(wreck: Wreck) {
        CKManager.delete(item: wreck) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    guard let currentIndex = self?.allWrecks.firstIndex(where: { $0 == wreck }) else {
                        DispatchQueue.main.async {
                            self?.showError(withMessage: "Collection not found")
                        }
                        return
                    }
                    self?.collectionWrecks.remove(at: currentIndex)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
}

//MARK: Private functions

extension CollectionsViewModel {
    
    private func getImageURL(fromData imageData: Data?) -> URL? {
        let randomID = UUID().uuidString
        guard let data = imageData else { return nil }
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(randomID) else { return nil }
        
        do {
            try data.write(to: url)
        } catch let error {
            DispatchQueue.main.async {
                self.showError(withMessage: error.localizedDescription)
            }
        }
        return url
    }
}
