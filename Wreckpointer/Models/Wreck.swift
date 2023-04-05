//
//  WreckModel.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 13.03.2023.
//

import CloudKit

struct Wreck: Identifiable, Equatable, CKCodable {
    let id: String
    var title: String
    var imageURL: URL?
    var depth: Double
    var latitude: Double
    var longitude: Double
    var dateOfLoss: Date
    var description: String
    var recordMetadata: Data
    
    init?(record: CKRecord) {
        guard let wreckTitle = record["title"] as? String else { return nil }
        guard let wreckDepth = record["depth"] as? Double else { return nil }
        guard let wreckLatitude = record["latitude"] as? Double else { return nil }
        guard let wreckLongitude = record["longitude"] as? Double else { return nil }
        guard let wreckDateOfLoss = record["dateOfLoss"] as? Date else { return nil }
        guard let wreckDescription = record["description"] as? String else { return nil }
        let wreckImage = record["image"] as? CKAsset
        var wreckMetadata: Data {
            let coder = NSKeyedArchiver(requiringSecureCoding: true)
            record.encodeSystemFields(with: coder)
            return coder.encodedData
        }
        
        self.id = record.recordID.recordName
        self.title = wreckTitle
        self.imageURL = wreckImage?.fileURL
        self.recordMetadata = wreckMetadata
        self.depth = wreckDepth
        self.latitude = wreckLatitude
        self.longitude = wreckLongitude
        self.dateOfLoss = wreckDateOfLoss
        self.description = wreckDescription
    }
    
    init?(title: String,
          imageURL: URL? = nil,
          depth: Double,
          latitude: Double,
          longitude: Double,
          dateOfLoss: Date,
          description: String) {
        
        // Creating CKRecord
        let wreckCKRecord = CKRecord(recordType: "Wreck")
        wreckCKRecord["title"] = title
        wreckCKRecord["depth"] = depth
        wreckCKRecord["latitude"] = latitude
        wreckCKRecord["longitude"] = longitude
        wreckCKRecord["dateOfLoss"] = dateOfLoss
        wreckCKRecord["description"] = description
        
        // Adding image if any
        if let url = imageURL {
            let asset = CKAsset(fileURL: url)
            wreckCKRecord["image"] = asset
        }
        
        // Initializing collection
        self.init(record: wreckCKRecord)
    }
    
    init(id: String, title: String, imageURL: URL? = nil, recordMetadata: Data, depth: Double, latitude: Double, longitude: Double, dateOfLoss: Date, description: String) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.recordMetadata = recordMetadata
        self.depth = depth
        self.latitude = latitude
        self.longitude = longitude
        self.dateOfLoss = dateOfLoss
        self.description = description
    }
}

extension Wreck {
    
    static let zeroWreck: Wreck = Wreck(id: "zero", title: "Zero wreck jkhgjkhghjkgjkhghjkgkhjg", recordMetadata: Data(), depth: 3800, latitude: 49, longitude: -43, dateOfLoss: Date(), description: "This is a sample wreck")
    
    var record: CKRecord? {
        do {
            let coder = try NSKeyedUnarchiver(forReadingFrom: recordMetadata)
            guard let record = CKRecord(coder: coder) else { return nil }
            coder.finishDecoding()
            
            record["title"] = title
            record["description"] = description
            record["depth"] = depth
            record["latitude"] = latitude
            record["longitude"] = longitude
            record["dateOfLoss"] = dateOfLoss
            
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
                newImageURL: URL? = nil,
                newDepth: Double,
                newLatitude: Double,
                newLongitude: Double,
                newDateOfLoss: Date) -> Wreck? {
        guard let record = record else { return nil }
        
        record["title"] = newTitle
        record["description"] = newDescription
        record["depth"] = newDepth
        record["latitude"] = newLatitude
        record["longitude"] = newLongitude
        record["dateOfLoss"] = newDateOfLoss
        
        if let url = newImageURL {
            let asset = CKAsset(fileURL: url)
            record["image"] = asset
        }
        
        return Wreck(record: record)
    }
}
