//
//  JSONDataCoder.swift
//  RememberX
//
//  Created by Danylo Ternovoi on 04.06.2023.
//

import Foundation

class JSONDataCoder {
    
    private let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    static let shared = JSONDataCoder()
    private init() { }
    
    func encodeItemToData<T: Codable>(item: T) throws -> Data {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let data = try encoder.encode(item)
        return data
    }
    
    func decodeItemFromData<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let item = try? decoder.decode(T.self, from: data) else {
            throw HTTPError.notDecodable("Recieved JSON items are not decodable")
        }
        return item
    }
    
    func encodeArrayToData<T: Codable>(items: [T]) throws -> Data {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let data = try encoder.encode(items)
        return data
    }
    
    func decodeArrayFromData<T: Codable>(data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let items = try? decoder.decode([T].self, from: data) else {
            throw HTTPError.notDecodable("Recieved JSON items are not decodable")
        }
        return items
    }
}
