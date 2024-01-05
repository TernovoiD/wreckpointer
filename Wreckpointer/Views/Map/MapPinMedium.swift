//
//  MapPinMedium.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

import SwiftUI

struct MapPinMedium: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        VStack(spacing: 0) {
            Text(wreck.hasName)
                .padding(.horizontal, 5)
                .font(.footnote.bold())
                .foregroundStyle(Color.white)
                .background(Color.mapPins)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Image(systemName: "diamond.inset.filled")
                .rotationEffect(Angle(degrees: 180))
        }
        .offset(y: -12)
    }
}

#Preview {
    MapPinMedium(wreck: Wreck.test)
}
