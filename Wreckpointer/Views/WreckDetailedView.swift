//
//  WreckDetailedView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.08.2023.
//

import SwiftUI

struct WreckDetailedView: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        ScrollView {
            wreckImage
            if let info = wreck.information {
                Text(info)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            infoPlate
            if let creator = wreck.creator {
                CreatorView(creator: creator)
            }
        }
    }
    
    var wreckImage: some View {
        ImageView(imageData: $wreck.image)
            .overlay {
                VStack {
                    Spacer()
                    Text(wreck.title)
                        .font(.largeTitle.weight(.bold))
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .background(.ultraThinMaterial)
                }
            }
    }
    
    var infoPlate: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Lost by: \(wreck.cause)")
                Text("Type of wreck: \(wreck.type)")
                Text("Date of loss: \(wreck.dateOfLoss?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")")
                Text("Wreck dive: \(wreck.wreckDive ? "Open" : "Not available")")
                    .padding(.bottom, 10)
                Text("Last update: \(wreck.updatedAt?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")")
                Text("Created: \(wreck.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")")
            }
            Spacer()
            VStack(alignment: .leading) {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 70)
                Text("Lat: \(abs(wreck.latitude), specifier: "%.2F") \(wreck.latitude >= 0 ? "N" : "S")")
                Text("Long: \(abs(wreck.longitude), specifier: "%.2F") \(wreck.longitude >= 0 ? "E" : "W")")
            }
        }
        .font(.subheadline)
        .padding()
        .neonField(light: true)
        .padding()
    }
}

struct WreckDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        WreckDetailedView(wreck: Wreck.test)
    }
}
