//
//  WreckPlateView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

import SwiftUI

struct WreckPlateView: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        HStack(alignment: .top) {
        ImageView(imageData: .constant(wreck.image))
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
        VStack(alignment: .leading, spacing: 5) {
            Text(wreck.hasName)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.primary)
            if wreck.hasDateOfLoss.isValid {
                Text("Date of loss: \(wreck.hasDateOfLoss.date.formatted(date: .abbreviated, time: .omitted))")
            }
            Text("Type: \(wreck.hasType.description)")
            Text("Cause: \(wreck.hasCause.description)")
        }
        .font(.subheadline)
        .foregroundStyle(Color.secondary)
        Spacer()
        VStack {
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.accentColor)
            Spacer()
        }
    }
        .foregroundStyle(Color.primary)
        .frame(height: 100)
    }
}

#Preview {
    WreckPlateView(wreck: Wreck.test)
}
