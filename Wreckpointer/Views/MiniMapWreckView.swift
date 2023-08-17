//
//  MiniMapWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.08.2023.
//

import SwiftUI
import MapKit

struct MiniMapWreckView: View {
    
    @StateObject var viewModel = MiniMapWreckViewModel()
    @EnvironmentObject private var appData: AppData
    @State private var wreck: Wreck = Wreck()
    @Binding var wreckID: String?
    
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
        .onAppear { updateWreck() }
        .onChange(of: wreckID) { _ in updateWreck() }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(lineWidth: 2))
        .padding()
    }
    
    private func updateWreck() {
        if let wreck = appData.wrecks.first(where: { $0.id == UUID(uuidString: wreckID ?? "") }) {
            self.wreck = wreck
        }
    }
}

struct MiniMapWreckView_Previews: PreviewProvider {
    static var previews: some View {
        MiniMapWreckView(wreckID: .constant(nil))
            .environmentObject(MiniMapWreckViewModel())
            .environmentObject(AppData())
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
        .frame(width: .infinity)
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
        ImageView(imageData: $wreck.image, placehoder: "warship.sunk")
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
            Text("Depth: \(Int(wreck.depth ?? 0))")
            Text("Type: \(wreck.type.capitalized)")
            Text("Cause: \(wreck.cause.capitalized)")
        }
        .font(.subheadline.weight(.bold))
        .frame(maxHeight: 150)
    }
}