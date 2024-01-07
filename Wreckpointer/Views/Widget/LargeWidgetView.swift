//
//  LargeWidgetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct LargeWidgetView: View {
    
    let wreck: Wreck
    let map: UIImage?
    
    var body: some View {
        ZStack {
            if let map {
                Image(uiImage: map)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .overlay {
                        MapPinMedium(wreck: wreck)
                    }
            }
            VStack {
                Spacer()
                ZStack {
                    ImageView(imageData: .constant(wreck.image))
                        .frame(height: 120)
                        .clipped()
                    HStack {
                        WreckInfoView(wreck: wreck)
                            .font(.footnote.bold())
                            .foregroundStyle(Color.white)
                            .shadow(color: .black, radius: 3)
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}

#Preview {
    LargeWidgetView(wreck: Wreck.test, map: nil)
        .frame(width: .infinity, height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
}
