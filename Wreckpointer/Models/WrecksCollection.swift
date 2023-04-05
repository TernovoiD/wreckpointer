//
//  CollectionModel.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 14.03.2023.
//

import CloudKit

struct WrecksCollection: Identifiable, Equatable, CKCodable {
    let id: String
    var imageURL: URL?
    var title: String
    var description: String
    var recordMetadata: Data
    
    init(id: String, imageURL: URL? = nil, title: String, description: String, recordMetadata: Data) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.recordMetadata = recordMetadata
    }
    
    init?(record: CKRecord) {
        guard let collectionTitle = record["title"] as? String else { return nil }
        guard let collectionDescription = record["description"] as? String else { return nil }
        let collectionImage = record["image"] as? CKAsset
        var collectionMetadata: Data {
            let coder = NSKeyedArchiver(requiringSecureCoding: true)
            record.encodeSystemFields(with: coder)
            return coder.encodedData
        }
        

        self.id = record.recordID.recordName
        self.imageURL = collectionImage?.fileURL
        self.title = collectionTitle
        self.description = collectionDescription
        self.recordMetadata = collectionMetadata
    }

    init?(imageURL: URL? = nil,
          title: String,
          description: String) {

        // Creating CKRecord
        let collectionCKRecord = CKRecord(recordType: "WrecksCollection")
        collectionCKRecord["title"] = title
        collectionCKRecord["description"] = description

        // Adding image if any
        if let url = imageURL {
            let asset = CKAsset(fileURL: url)
            collectionCKRecord["image"] = asset
        }

        // Initializing collection
        self.init(record: collectionCKRecord)
    }
}

extension WrecksCollection {
    
    static let zeroCollection = WrecksCollection(id: "zero", title: "Zero", description: "This is a sample collection", recordMetadata: Data())
    
    var record: CKRecord? {
        do {
            let coder = try NSKeyedUnarchiver(forReadingFrom: recordMetadata)
            guard let record = CKRecord(coder: coder) else { return nil }
            coder.finishDecoding()
            
            record["title"] = title
            record["description"] = description
            
            if let url = imageURL {
                let asset = CKAsset(fileURL: url)
                record["image"] = asset
            }
            
            return record
        } catch {
            return nil
        }
    }
    
    func update(newTitle: String,
                newDescription: String,
                newImageURL: URL? = nil) -> WrecksCollection? {
        
        guard let record = record else { return nil }
        
        record["title"] = newTitle
        record["description"] = newDescription
        
        if let url = newImageURL {
            let asset = CKAsset(fileURL: url)
            record["image"] = asset
        }
        
        return WrecksCollection(record: record)
    }
}
