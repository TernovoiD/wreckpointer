//
//  MapPinView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import SwiftUI

struct MapPinView: View {
    
    @EnvironmentObject var wrecks: Wrecks
    @State var wreck: Wreck
    
    var body: some View {
        VStack {
            if wrecks.selectedWreck == wreck {
                selectedWreck
            } else {
                regularWreck
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            wrecks.selectedWreck = wreck
                        }
                    }
            }
        }
        .onChange(of: wrecks.all) { wrecks in
            if let updatedWreck = wrecks.first(where: { $0.id == wreck.id }) {
                self.wreck = updatedWreck
            }
        }
    }
    
    var selectedWreck: some View {
        VStack {
            Text(wreck.title)
                .padding(5)
                .frame(width: 120)
                .bold()
                .foregroundColor(.black)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .frame(maxHeight: 25)
            Image(systemName: "triangle.fill")
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -5)
            Spacer()
        }
        .frame(maxHeight: 60)
    }
    
    var regularWreck: some View {
        VStack {
            Image(systemName: "plus.circle")
        }
    }
}

struct MapPinView_Previews: PreviewProvider {
    static var previews: some View {
        let testWreck: Wreck = Wreck(cause: "something", type: "other", title: "Titanic", latitude: 50, longitude: 50, wreckDive: false)
        ZStack {
            Color.blue.ignoresSafeArea()
            MapPinView(wreck: testWreck)
                .environmentObject(Wrecks())
        }
    }
}
