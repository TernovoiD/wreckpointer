//
//  MapPanelView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 08.12.2023.
//

import SwiftUI

struct MapPanelView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack {
            HStack {
                ForEach(MapOverlayElements.allCases) { element in
                    MapPanelButton(title: element.rawValue.capitalized, action: { changeActiveUIElement(on: element) })
                        .foregroundStyle(viewModel.activeMapOverlayElement == element ? Color.accentColor : .gray)
                }
            }
            .frame(height: 20)
            
            if viewModel.activeMapOverlayElement == .search {
                MapSearchBarView(viewModel: viewModel)
            } else if viewModel.activeMapOverlayElement == .filter {
                MapFilterView(viewModel: viewModel)
            } else if viewModel.activeMapOverlayElement == .add {
                AddWreckView(wreck: Wreck.test)
            }
        }
        .padding()
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.5), radius: 5)
        .padding()
    }
    
    private func changeActiveUIElement(on element: MapOverlayElements) {
        withAnimation(.bouncy) {
            viewModel.activeMapOverlayElement = element
        }
    }
}

struct MapPanelButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Color.clear
                .overlay {
                    Text(title)
                }
        })
    }
}

#Preview {
    MapPanelView(viewModel: MapViewModel())
        .environmentObject(WreckpointerData())
        .background(Color.yellow)
}
