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
        HStack(alignment: .center) {
            ImageView(imageData: .constant(wreck.image))
                .aspectRatio(contentMode: .fill)
                .frame(width: 75, height: 75)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack(alignment: .leading, spacing: 0) {
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
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.accent)
        }
        .foregroundStyle(Color.primary)
    }
}

#Preview {
    WreckPlateView(wreck: Wreck.test)
        .padding(.horizontal)
}
