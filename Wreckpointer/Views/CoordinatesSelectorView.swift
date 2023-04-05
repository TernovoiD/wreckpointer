//
//  CoordinatesSelectorView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.04.2023.
//

import SwiftUI

struct CoordinatesSelectorView: View {
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    var body: some View {
        VStack {
            latitudePicker
                .padding()
                .foregroundStyle(.black)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding()
            longitudePicker
                .padding()
                .foregroundStyle(.black)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding()
        }
        .background(Color.gray.opacity(0.17))
    }
}

struct CoordinatesSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatesSelectorView(latitude: .constant(0), longitude: .constant(0))
    }
}

// MARK: Content

extension CoordinatesSelectorView {
    
    var latitudePicker: some View {
        VStack(alignment: .leading) {
            Text("Latitude: \(latitude, specifier: "%.4F")")
            Slider(value: $latitude, in: -90...90, step: 1)
            Stepper("Minutes", value: $latitude, in: -90...90, step: 0.01)
            Stepper("Seconds", value: $latitude, in: -90...90, step: 0.0001)
        }
    }
    
    var longitudePicker: some View {
        VStack(alignment: .leading) {
            Text("Longitude: \(longitude, specifier: "%.4F")")
            Slider(value: $longitude, in: -180...180, step: 1)
            Stepper("Minutes", value: $longitude, in: -180...180, step: 0.01)
            Stepper("Seconds", value: $longitude, in: -180...180, step: 0.0001)
        }
    }
}
