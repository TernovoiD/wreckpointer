//
//  MediumWidgetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct MediumWidgetView: View {
    
    let wreck: Wreck
    let map: UIImage?
    
    var body: some View {
        ZStack {
            if let map {
                Image(uiImage: map)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .shadow(color: .black, radius: 3)
                    .overlay {
                        MapPinMedium(wreck: wreck)
                            .scaleEffect(0.8)
                            .foregroundStyle(Color.white)
                    }
            }
            HStack {
                ImageView(imageData: .constant(wreck.image))
                    .frame(maxWidth: 90, maxHeight: 90)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                Spacer()
            }
            .padding()
        }
    }
    
    private var wreckImage: some View {
        ImageView(imageData: .constant(wreck.image))
            .frame(width: 60, height: 60)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 9))
            .overlay {
                VStack {
                    Spacer()
                    Text(wreck.hasName)
                        .font(.caption2.weight(.black))
                        .foregroundStyle(Color.white)
                        .shadow(color: .black, radius: 3)
                }
            }
    }
}

#Preview {
    ZStack {
        Color.green
        MediumWidgetView(wreck: Wreck.test, map: UIImage(named: "RMSLusitaniaMap"))
            .frame(width: .infinity, height: 150)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
    }
}
