//
//  MediumWidgetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct MediumWidgetView: View {
    
    let wreck: Wreck
    
    var body: some View {
        ZStack {
            ImageView(imageData: .constant(wreck.image))
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(wreck.hasName)
                        .font(.headline.weight(.black))
                        .foregroundStyle(Color.white)
                        .shadow(color: .black, radius: 3)
                    WreckInfoView(wreck: wreck)
                    .font(.caption.bold())
                    .foregroundStyle(Color.white)
                    .shadow(color: .black, radius: 3)
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    MediumWidgetView(wreck: Wreck.test)
        .frame(width: .infinity, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
}
