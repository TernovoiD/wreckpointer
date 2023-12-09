//
//  NameAndCoordinatesPlate.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckRequiredFieldsPlate: View {
    
    @Binding var name: String
    
    //Latitude
    @Binding var latitudeDegrees: String
    @Binding var latitudeMinutes: String
    @Binding var latitudeSeconds: String
    @Binding var latitudeNorth: Bool
    //Longitude
    @Binding var longitudeDegrees: String
    @Binding var longitudeMinutes: String
    @Binding var longitudeSeconds: String
    @Binding var longitudeEast: Bool
    
    
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("RMS Titanic", text: $name)
                .padding()
                .coloredBorder(color: .gray)
            latitude
            longitude
        }
        .padding()
    }
    
    private var latitude: some View {
        HStack {
            Text("Latitude")
                .font(.callout)
            Spacer()
            TextField("51", text: $latitudeDegrees).degree(symbol: "°")
            TextField("28", text: $latitudeMinutes).degree(symbol: "′")
            TextField("38", text: $latitudeSeconds).degree(symbol: "″")
            Button(action: { latitudeNorth.toggle() }, label: {
                Text(latitudeNorth ? "N" : "S")
            })
        }
        .font(.title3.bold())
    }
    
    private var longitude: some View {
        HStack {
            Text("Longitude")
                .font(.callout)
            Spacer()
            TextField("51", text: $longitudeDegrees).degree(symbol: "°")
            TextField("28", text: $longitudeMinutes).degree(symbol: "′")
            TextField("38", text: $longitudeSeconds).degree(symbol: "″")
            Button(action: { longitudeEast.toggle() }, label: {
                Text(longitudeEast ? "E" : "W")
            })
        }
        .font(.title3.bold())
    }
}

#Preview {
    WreckRequiredFieldsPlate(name: .constant(""), latitudeDegrees: .constant(""), latitudeMinutes: .constant(""), latitudeSeconds: .constant(""), latitudeNorth: .constant(true), longitudeDegrees: .constant(""), longitudeMinutes: .constant(""), longitudeSeconds: .constant(""), longitudeEast: .constant(true))
}
