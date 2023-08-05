//
//  WreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.07.2023.
//

import SwiftUI

struct WreckView: View {
    
    let wreck: Wreck
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center) {
                wreckImage
                wreckTitle
            }
            wreckInfo
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .neonField(light: true)
    }
    
    var wreckImage: some View {
        Image("battleship.logo")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 50, maxHeight: 50)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
    
    var wreckTitle: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(wreck.title)
                .font(.title3)
                .bold()
            Text("Created: \(wreck.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? "unknown")")
                .font(.subheadline)
        }
    }
    
    var wreckInfo: some View {
        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
            .font(.caption2)
            .frame(maxHeight: 40)
    }
}

struct WreckView_Previews: PreviewProvider {
    static var previews: some View {
        let wreck = Wreck(cause: "other", type: "other", title: "Titanic", latitude: 3241, longitude: 1234, wreckDive: false)
        WreckView(wreck: wreck)
    }
}
