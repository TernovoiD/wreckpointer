//
//  WreckRowView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import SwiftUI

struct WreckRow: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        Text(wreck.hasName)
    }
}

#Preview {
    WreckRow(wreck: Wreck.test)
}
