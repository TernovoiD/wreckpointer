//
//  WreckRowView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.12.2023.
//

import SwiftUI

struct WreckRowView: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        HStack {
//            ImageView(imageData: $wreck.image)
//                .frame(maxWidth: 40, maxHeight: 40)
//                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            VStack(alignment: .leading, spacing: 0) {
                Text(wreck.name)
                    .font(.headline.weight(.bold))
                Text("Date of loss: \(wreck.dateOfLoss?.formatted(date: .abbreviated, time: .omitted) ?? "unknown")")
                    .font(.subheadline.weight(.semibold))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.accentColor)
        }
        .padding(.leading)
    }
}

#Preview {
    WreckRowView(wreck: Wreck.test)
}
