//
//  SmallWidgetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct SmallWidgetView: View {
    
    let wreck: Wreck
    
    var body: some View {
        ImageView(imageData: .constant(wreck.image))
            .overlay {
                VStack {
                    Text(wreck.hasName)
                        .font(.footnote.weight(.black))
                        .foregroundStyle(Color.white)
                        .shadow(color: .black, radius: 3)
                    Spacer()
                }
                .padding(5)
            }
    }
}

#Preview {
    ZStack {
        Color.green
        SmallWidgetView(wreck: Wreck.test)
            .frame(width: 150, height: 150)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
    }
}
