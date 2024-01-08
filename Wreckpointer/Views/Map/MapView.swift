//
//  MapView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 28.12.2023.
//

import SwiftUI

struct MapView: View {
    
    @StateObject var viewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                iOS14WreckpointerMap(map: viewModel)
                    .ignoresSafeArea(edges: .top)
                if viewModel.activeUIElement != nil || viewModel.selectedWreck != nil {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea(edges: .top)
                        .onTapGesture {
                            withAnimation(.spring) {
                                viewModel.activeUIElement = .none
                                viewModel.selectedWreck = nil
                            }
                        }
                }
                MapOverlayView(map: viewModel)
                    .padding(.top)
            }
            .task {
                await viewModel.loadWrecks()
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(MapViewModel())
}
