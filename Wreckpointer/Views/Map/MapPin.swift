//
//  MapPin.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 18.01.2024.
//

import SwiftUI

struct MapPin: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(wreck.hasName)
                        .font(.headline.weight(.black))
                }
                HStack(spacing: 0) {
                    Text("\(abs(wreck.hasCoordinates.latitude), specifier: "%.2f")")
                    Text(wreck.hasCoordinates.latitude > 0 ? "N" : "S")
                        .padding(.trailing, 10)
                    Text("\(abs(wreck.hasCoordinates.longitude), specifier: "%.2f")")
                    Text(wreck.hasCoordinates.longitude > 0 ? "E" : "W")
                }
                .font(.footnote)
            }
            .frame(height: 40)
            Image(systemName: "diamond.inset.filled")
                .rotationEffect(Angle(degrees: 180))
        }
        .foregroundStyle(Color.white)
        .shadow(color: .black, radius: 5)
        .shadow(radius: 5)
        .offset(y: -21)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [Color.blue, Color.green], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        MapPin(wreck: Wreck.test)
    }
}
