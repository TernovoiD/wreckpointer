//
//  WreckRowView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.12.2023.
//

import SwiftUI

struct WreckRowView: View {
    
    @State var wreck: Wreck
    @State var arrow: Bool = true
    
    var body: some View {
        HStack {
            Image(systemName: "ferry")
            VStack(alignment: .leading, spacing: 0) {
                Text(wreck.hasName)
                    .font(.subheadline.weight(.medium))
                let lossDate = wreck.hasDateOfLoss.isValid ? "\(wreck.hasDateOfLoss.date.formatted(date: .abbreviated, time: .omitted))" : "unknown"
                Text("Date of loss: " + lossDate)
                    .font(.caption.weight(.medium))
            }
            Spacer()
            if arrow {
                Image(systemName: "chevron.right")
                    .font(.headline.bold())
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    WreckRowView(wreck: Wreck.test)
}
