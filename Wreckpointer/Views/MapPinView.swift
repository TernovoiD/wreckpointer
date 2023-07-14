//
//  MapPinView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapPinView: View {
    let wreck: Wreck
    var body: some View {
        Text(wreck.title)
            .padding(.horizontal, 3)
            .background()
            .mask(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}

struct MapPinView_Previews: PreviewProvider {
    static var previews: some View {
        let testWreck: Wreck = Wreck(cause: "something", type: "other", title: "Titanic", latitude: 50, longitude: 50, wreckDive: false)
        ZStack {
            Color.blue
                .ignoresSafeArea()
            MapPinView(wreck: testWreck)
        }
    }
}
