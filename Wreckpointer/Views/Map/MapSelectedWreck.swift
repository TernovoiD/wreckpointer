//
//  MapSelectedWreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.12.2023.
//

import SwiftUI

struct MapSelectedWreck: View {
    
    @ObservedObject var viewModel: MapViewModel
    @State var wreck: Wreck
    @State var tabSelection: Int = 0
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                ForEach(0..<2) { i in
                    Image(systemName: "circle.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(tabSelection == i ? Color.accentColor : Color.gray)
                }
            }
            .padding(3)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            TabView(selection: $tabSelection) {
                infoPlate
                    .tag(0)
                descriptionPlate
                    .tag(1)
            }
            .frame(maxWidth: .infinity, maxHeight: 150)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .gray.opacity(0.5), radius: 5)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay { closeButton.offset(x: 10, y: -5) }
        }
        .padding()
    }
    
    private var infoPlate: some View {
        VStack {
            HStack {
                charachteristics
                Spacer()
//                ImageView(imageData: $wreck.imageData)
//                    .frame(maxWidth: 300, maxHeight: 150)
//                    .clipped()
            }
        }
    }
    
    private var descriptionPlate: some View {
        ScrollView {
            Text(wreck.history ?? "")
        }
        .padding()
    }
    
    private var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewModel.selectedWreck = nil
                } label: {
                    Text("Close")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .foregroundStyle(Color.primary)
                        .font(.caption.bold())
                }
            }
            Spacer()
        }
    }
    
    private var charachteristics: some View {
        VStack(alignment: .leading) {
            Text(wreck.name)
                .font(.callout.bold())
                .foregroundStyle(Color.primary)
            Spacer()
            Text("Latitude: " + String(wreck.latitude))
            Text("Longitude: " + String(wreck.longitude))
//            Text("Cause: " + String(wreck.cause?.capitalized ?? ""))
//            Text("Type: " + String(wreck.type?.capitalized ?? ""))
            Text("Depth: " + String(wreck.depth ?? 0))
            Text("Deadweight: " + String(wreck.deadweight ?? 0))
            Text("Loss of Life: " + String(wreck.lossOfLife ?? 0))
        }
        .frame(maxHeight: 150)
        .padding(.leading, 10)
        .padding(5)
        .font(.caption)
        .foregroundStyle(Color.secondary)
    }
}

#Preview {
    MapSelectedWreck(viewModel: MapViewModel(), wreck: Wreck.test)
}
