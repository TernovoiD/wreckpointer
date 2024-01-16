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
            if wreck.hasDisplacement.isValid {
                Text("Displacement:  \(String(wreck.hasDisplacement.tons)) tons")
                    .padding(.bottom, 10)
            } else {
                Text("Displacement: unknown")
                    .padding(.bottom, 10)
            }
            if wreck.hasDateOfLoss.isValid {
                Text("Date of loss:  \(wreck.hasDateOfLoss.date.formatted(date: .abbreviated, time: .omitted))")
            } else {
                Text("Date of loss: unknown")
            }
            Text("Cause: \(wreck.hasCause.description)")
            if wreck.hasDepth.isValid {
                Text("Depth: \(wreck.hasDepth.ft) ft.")
            } else {
                Text("Depth: unknown")
            }
            if wreck.hasLossOfLife.isValid {
                Text("Loss of Life:  \(wreck.hasLossOfLife.souls)")
            }
        }
    }
}

#Preview {
    WreckInfoView(wreck: Wreck.test)
}
