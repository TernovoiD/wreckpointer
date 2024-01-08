//
//  WreckInfoView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct WreckInfoView: View {
    
    let wreck: Wreck
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(wreck.hasType.description)
            Text("Displacement:  \(String(wreck.hasDisplacement.tons)) tons")
                .padding(.bottom, 10)
            Text("Date of loss:  \(wreck.hasDateOfLoss.date.formatted(date: .abbreviated, time: .omitted))")
            Text("Cause:  \(wreck.hasCause.description)")
            Text("Depth:  \(wreck.hasDepth.ft) ft.")
            Text("Loss of Life:  \(wreck.hasLossOfLife.souls)")
        }
    }
}

#Preview {
    WreckInfoView(wreck: Wreck.test)
}
