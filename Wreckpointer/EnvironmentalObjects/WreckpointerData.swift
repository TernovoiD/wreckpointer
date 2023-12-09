//
//  WreckpointerData.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import Foundation

@MainActor
final class WreckpointerData: ObservableObject {
    @Published var wrecks: [Wreck] = [ ]
}
