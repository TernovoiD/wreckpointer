//
//  WreckPlateView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

import SwiftUI

struct WreckPlateView: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        ImageView(imageData: $wreck.image)
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(wreck.hasName)
                            .font(.title3.weight(.black))
                            .foregroundStyle(Color.white)
                            .shadow(color: .black, radius: 3)
                            .offset(y: 9)
                    }
                }
            }
            .shadow(radius: 3)
    }
}

#Preview {
    WreckPlateView(wreck: Wreck.test)
}
