//
//  SmallWidgetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct SmallWidgetView: View {
    
    let wreck: Wreck
    let subscription: Bool
    
    var body: some View {
        if subscription {
            widget
        } else {
            subscriptionPlaceholder
            .padding(10)
        }
    }
    
    private var widget: some View {
        ImageView(imageData: .constant(wreck.image))
            .overlay {
                VStack {
                    Text(wreck.hasName)
                        .font(.headline.weight(.black))
                        .foregroundStyle(Color.white)
                        .shadow(color: .black, radius: 3)
                    Spacer()
                }
                .padding(5)
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
        SmallWidgetView(wreck: Wreck.test, subscription: true)
            .frame(width: 150, height: 150)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
    }
}
