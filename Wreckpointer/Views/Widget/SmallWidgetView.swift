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
    }
}

#Preview {
    SmallWidgetView(wreck: Wreck.test)
        .frame(width: 150, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
}
