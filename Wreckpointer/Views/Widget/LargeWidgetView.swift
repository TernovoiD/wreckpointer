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
            ImageView(imageData: .constant(wreck.image))
            VStack {
                HStack(alignment: .top, spacing: 15) {
                    Spacer()
                    Text(wreck.hasName)
                        .font(.title2.weight(.black))
                        .shadow(color: .black, radius: 3)
                        .foregroundStyle(Color.white)
                }
                Spacer()
                Text(wreck.history ?? "")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.white)
                    .shadow(color: .black, radius: 3)
                    .frame(maxHeight: 70)
            }
            .padding()
        }
    }
}

#Preview {
    LargeWidgetView(wreck: Wreck.test, map: UIImage(named: "RMSLusitania"))
        .frame(width: .infinity, height: 360)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
}
