//
//  SelectedWreckPanel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.04.2023.
//

import SwiftUI

struct SelectedWreckPanel: View {
    @EnvironmentObject var mapVM: MapViewModel
    let wreck: Wreck
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(wreck.title)
                .font(.headline)
                .frame(height: 50)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            VStack {
                nextWreckButton
                learMoreButton
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThickMaterial)
        .overlay {
            HStack {
                wreckImage
                    .padding(.leading)
                    .offset(y: -100)
                Spacer()
            }
        }
    }
}

// MARK: Preview

struct SelectedWreckPanel_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            VStack {
                Spacer()
                SelectedWreckPanel(wreck: Wreck.zeroWreck)
                    .environmentObject(MapViewModel())
            }
        }
    }
}

// MARK: Content

extension SelectedWreckPanel {
    
    
    private var wreckImage: some View {
        AsyncImage(url: wreck.imageURL) { image in
            image
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: 190)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        mapVM.mapSelectedWreck = mapVM.mapSelectedWreck
                    }
                }
        } placeholder: {
            Image("battleship.logo")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: 190)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        mapVM.mapSelectedWreck = mapVM.mapSelectedWreck
                    }
                }
        }
    }
    
}

// MARK: Buttons

extension SelectedWreckPanel {
    
    private var nextWreckButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.nextWreck()
            }
        } label: {
            Text("Next")
                .padding()
                .frame(maxWidth: 150, maxHeight: 50)
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    private var learMoreButton: some View {
        Button {
            mapVM.mapDetailedWreckView = mapVM.mapSelectedWreck
        } label: {
            Text("Learn more")
                .padding()
                .frame(maxWidth: 150, maxHeight: 50)
                .foregroundColor(.black)
                .background(.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
}
