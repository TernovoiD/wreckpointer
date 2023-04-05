//
//  PanelsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 26.03.2023.
//

import SwiftUI

struct PanelsView: View {
    @AppStorage("selectedTab") var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            tabOne
                .onTapGesture {
                    selectedTab = 1
                }
                .tag(0)
            tabTwo
                .onTapGesture {
                    selectedTab = 0
                }
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct PanelsView_Previews: PreviewProvider {
    static var previews: some View {
        PanelsView()
    }
}

// MARK: Design

extension PanelsView {
    
    private var tabOne: some View {
        Image("titanic.photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(
                VStack {
                    Spacer()
                    Text("Discover wrecks all around the globe")
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                })
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
    }
    
    private var tabTwo: some View {
        Image("bismarck.photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(
                VStack {
                    Spacer()
                    Text("Learn the tragedic histories of past")
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                })
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
    }
}
