//
//  MapView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 28.12.2023.
//

import SwiftUI

struct MapView: View {
    
    @StateObject var viewModel = MapViewModel()
    @EnvironmentObject var data: WreckpointerData
    
    var body: some View {
        NavigationView {
            ZStack {
                iOS14WreckpointerMap(map: viewModel)
                    .ignoresSafeArea(edges: .top)
                if viewModel.activeUIElement != nil {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea(edges: .top)
                        .onTapGesture {
                            withAnimation(.spring) {
                                viewModel.activeUIElement = .none
                            }
                        }
                }
                MapOverlayView(map: viewModel)
                    .padding(.top)
            }
            .ignoresSafeArea(.keyboard)
            .onAppear(perform: {
                viewModel.show(wrecks: data.wrecks)
            })
            .onChange(of: data.wrecks, perform: { wrecks in
                viewModel.show(wrecks: wrecks)
            })
            .onChange(of: viewModel.filteredWrecks, perform: { _ in
                viewModel.selectedWreck = nil
            })
        }
    }
}

#Preview {
    MapView()
        .environmentObject(MapViewModel())
        .environmentObject(WreckpointerData())
}
