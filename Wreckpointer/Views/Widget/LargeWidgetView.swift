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
    let subscription: Bool
    
    var body: some View {
        if subscription {
            widget
        } else {
            subscriptionPlaceholder
                .padding()
        }
    }
    
    private var widget: some View {
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
                            .font(.caption2.bold())
                            .foregroundStyle(Color.white)
                            .shadow(color: .black, radius: 3)
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
    
    private var subscriptionPlaceholder: some View {
        VStack {
            VStack(alignment: .trailing) {
                Text("Wreckpointer")
                    .font(.headline.weight(.black))
                Text(".project")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.accentColor)
            }
            Spacer()
            VStack(alignment: .center) {
                Text("Get .PRO subscription to unlock Wreckpointer.today widget.")
                    .font(.caption.bold())
                    .foregroundStyle(Color.secondary)
            }
        }
    }
}

#Preview {
    LargeWidgetView(wreck: Wreck.test, map: nil, subscription: true)
        .frame(width: .infinity, height: 360)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
}
