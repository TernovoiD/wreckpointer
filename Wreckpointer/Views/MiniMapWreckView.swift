//
//  MiniMapWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.08.2023.
//

import SwiftUI
import MapKit

struct MiniMapWreckView: View {
    
    @AppStorage("showFeetUnits") private var showFeetUnits: Bool = true
    @StateObject private var viewModel = MiniMapWreckViewModel()
    let wreck: Wreck
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                wreckImage
                wreckInfo
                Spacer()
            }
            VStack {
                map
                mapSlider
                    .padding(.bottom, 10)
            }
            .frame(height: 200)
            .background(Color.gray.opacity(0.15))
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(lineWidth: 2))
        .padding()
    }
}

struct MiniMapWreckView_Previews: PreviewProvider {
    static var previews: some View {
        MiniMapWreckView(wreck: Wreck.test)
            .environmentObject(MiniMapWreckViewModel())
    }
}

// MARK: - Variables

extension MiniMapWreckView {
    
    private var map: some View {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: [wreck]) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude,
                                                             longitude: wreck.longitude)) {
                Image(systemName: "smallcircle.circle")
                    .bold()
                    .foregroundColor(.red)
            }
        }
        .onAppear{ viewModel.changeMapRegion(latitude: wreck.latitude, longitude: wreck.longitude) }
        .disabled(true)
    }
    
    private var mapSlider: some View {
        Slider(value: $viewModel.mapSpan, in: 1...30, step: 1) { value in
            viewModel.adjustMapSpan()
        }
        .padding(.horizontal)
    }
    
    private var wreckImage: some View {
        ImageView(imageData: .constant(wreck.image), placehoder: "warship.sunk")
            .frame(maxWidth: 150, maxHeight: 150)
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .clipped()
    }
    
    private var wreckInfo: some View {
        VStack(alignment: .leading) {
            Text("Name: \(wreck.title)")
            Text("Date: \(wreck.dateOfLoss?.formatted(date: .numeric, time: .omitted) ?? "Unknown")")
            Text("Lat: \(abs(wreck.latitude), specifier: "%.2F") \(wreck.latitude >= 0 ? "N" : "S")")
            Text("Long: \(abs(wreck.longitude), specifier: "%.2F") \(wreck.longitude >= 0 ? "E" : "W")")
            Text(showFeetUnits ? "Depth: \(Int(wreck.depth?.metersToFeet ?? 0)) ft" : "Depth: \(Int(wreck.depth ?? 0)) m")
            Text("Type: \(wreck.type.capitalized)")
            Text("Cause: \(wreck.cause.capitalized)")
        }
        .font(.subheadline.weight(.bold))
        .frame(maxHeight: 150)
    }
}
