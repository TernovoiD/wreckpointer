//
//  HomePageModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

struct HomePageModel: Codable {
    let random5Wrecks: [Wreck]
    let last3ApprovedWrecks: [Wreck]
    let modernHistory6Wrecks: [Wreck]
}
