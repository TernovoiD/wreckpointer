//
//  MapPinSelecredView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.08.2023.
//

import SwiftUI

struct MapPinSelecredView: View {
    
    let wreck: Wreck
    
    var body: some View {
        VStack(spacing: 0) {
            Text(wreck.title)
                .padding(3)
                .bold()
                .foregroundColor(.black)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .frame(maxHeight: 20)
            Image(systemName: "triangle.fill")
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -4)
            Spacer()
        }
        .frame(maxHeight: 60)
//        .background(Color.red)
    }
}

struct MapPinSelecredView_Previews: PreviewProvider {
    static var previews: some View {
        
        let testWreck: Wreck = Wreck(cause: "something", type: "other", title: "Titanic", latitude: 50, longitude: 50, wreckDive: false)
        
        ZStack {
            Color.blue.ignoresSafeArea()
            MapPinSelecredView(wreck: testWreck)
        }
    }
}
