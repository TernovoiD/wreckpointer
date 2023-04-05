//
//  MapPinView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 29.03.2023.
//

import SwiftUI

struct MapPinView: View {
    @EnvironmentObject var mapVM: MapViewModel
    let wreck: Wreck
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                wreckImage
                    .frame(maxWidth: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                Text(wreck.title)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .frame(maxWidth: 100, maxHeight: 50)
            }
            .padding(.horizontal, 5)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .onTapGesture {
                withAnimation(.spring()) {
                    if mapVM.mapSelectedWreck == wreck {
                        mapVM.mapSelectedWreck = nil
                    } else {
                        mapVM.mapSelectedWreck = wreck
                    }
                    
                }
            }
            Image(systemName: "arrowtriangle.down.fill")
                .foregroundColor(.white)
                .offset(y: -3)
            Spacer()
        }
        .frame(maxHeight: 120)
    }
}

struct MapPinView_Previews: PreviewProvider {
    static var previews: some View {
        MapPinView(wreck: Wreck.zeroWreck)
            .padding()
            .background(.cyan)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .environmentObject(MapViewModel())
    }
}

// MARK: Content

extension MapPinView {
    
    private var wreckImage: some View {
        AsyncImage(url: wreck.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Image("battleship.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
