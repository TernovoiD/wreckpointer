//
//  SelectedWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

import SwiftUI

struct SelectedWreckView: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                Text(wreck.hasName)
                    .font(.title.weight(.black))
                info
                .font(.callout)
            }
            .padding(15)
            RoundedRectangle(cornerRadius: 1)
                .frame(maxHeight: 2)
            readButton
                .frame(maxHeight: 40)
        }
    }
    
    private var info: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Type: \(wreck.hasType.description)")
                Text("Cause: \(wreck.hasCause.description)")
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Latitude: \(wreck.hasCoordinates.latitude, specifier: "%.2f")")
                Text("Longitude: \(wreck.hasCoordinates.longitude, specifier: "%.2f")")
            }
        }
    }
    
    private var readButton: some View {
        NavigationLink {
            WreckView(wreck: wreck)
        } label: {
            Color.clear
                .overlay {
                    Text("Read")
                }
                .foregroundStyle(Color.primary)
                .font(.headline.bold())
        }
    }
}

#Preview {
    SelectedWreckView(wreck: Wreck.test)
        .coloredBorder(color: .primary)
        .padding(12)
}
