//
//  File.swift
//  
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

struct ServerInfoModel: Codable {
    let databaseWrecks: [Wreck]
    let todayWrecks: [Wreck]
    let lastApprovedWrecks: [Wreck]
    let randomWrecks: [Wreck]
    let modernHistoryWrecks: [Wreck]
}
