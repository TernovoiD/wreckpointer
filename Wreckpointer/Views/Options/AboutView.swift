//
//  AboutView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.01.2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            Image("theCreator")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
            Text("Greetings, I'm Danylo Ternovoi—an iOS developer, former navigation officer, and the mind behind Wreckpointer. This project serves as a dynamic tool for discovery, learning, and exploration. \n\nWreckpointer is fueled by my enthusiasm for cutting-edge technologies, a deep passion for history, and an unwavering curiosity about the mysteries hidden beneath the ocean's surface.")
                .foregroundStyle(Color.secondary)
                .font(.callout.weight(.bold))
                .padding()
                .padding(.horizontal)
            Spacer()
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
