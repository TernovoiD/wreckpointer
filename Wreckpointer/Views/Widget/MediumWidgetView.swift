//
//  MediumWidgetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct MediumWidgetView: View {
    
    let wreck: Wreck
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
            ImageView(imageData: .constant(wreck.image))
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(wreck.hasName)
                        .font(.headline.weight(.black))
                        .foregroundStyle(Color.white)
                        .shadow(color: .black, radius: 3)
                    WreckInfoView(wreck: wreck)
                        .font(.caption2.bold())
                    .foregroundStyle(Color.white)
                    .shadow(color: .black, radius: 3)
                }
                Spacer()
            }
            .padding()
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
    ZStack {
        Color.green
        MediumWidgetView(wreck: Wreck.test, subscription: false)
            .frame(width: .infinity, height: 150)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
    }
}
