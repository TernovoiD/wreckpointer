//
//  WreckRowView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.04.2023.
//

import SwiftUI

struct WreckRowView: View {
    let wreck: Wreck
    var body: some View {
        HStack(spacing: 10) {
            wreckImage
            VStack(alignment: .leading, spacing: 5) {
                Text(wreck.title)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                Text(wreck.dateOfLoss.formatted(date: .long, time: .omitted))
                    .foregroundColor(.primary)
                
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.17))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal)
    }
}

// MARK: Preview

struct WreckRowView_Previews: PreviewProvider {
    static var previews: some View {
        WreckRowView(wreck: Wreck.zeroWreck)
    }
}

// MARK: Content

extension WreckRowView {
    
    var wreckImage: some View {
            AsyncImage(url: wreck.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } placeholder: {
                Image("battleship.logo")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
    }
}
