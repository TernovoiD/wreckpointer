//
//  WreckSelector.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

import SwiftUI

struct WreckSelector: View {
    
    @State private var selectedTabIndex: Int = 0
    @Binding var wrecks: [Wreck]
    @State private var presentedWreck: Wreck?
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTabIndex) {
                ForEach(0..<wrecks.count, id: \.self) { wreckNumber in
                    GeometryReader { proxy in
                        NavigationLink(destination: {
                            WreckView(wreck: wrecks[wreckNumber])
                        }, label: {
                            ImageView(imageData: $wrecks[wreckNumber].image)
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: proxy.size.width - 30, maxHeight: 400)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .rotation3DEffect(.degrees(proxy.frame(in: .global).minX / -10), axis: (x: 0, y: 1, z: 0))
                                .blur(radius: abs(proxy.frame(in: .global).minX) / 50)
                                .overlay(
                                    Text(wrecks[wreckNumber].hasName)
                                        .font(.title2.weight(.black))
                                        .foregroundStyle(Color.white)
                                        .shadow(color: .black, radius: 3)
                                        .offset(x: 0, y: 120)
                                        .frame(maxWidth: 200)
                                        .offset(x: proxy.frame(in: .global).minX))
                        })
                        .padding()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            VStack {
                Spacer()
                selectedTabIndicator
            }
        }
        .frame(height: 400)
        .sheet(item: $presentedWreck) { wreck in
            WreckView(wreck: wreck)
        }
    }
    
    private var selectedTabIndicator: some View {
        HStack(spacing: 6){
            ForEach(0..<wrecks.count, id: \.self) { i in
                          Image(systemName: "circle.fill")
                              .font(.system(size: 9))
                              .foregroundStyle(selectedTabIndex == i ? .accent : .gray)
                       }
             }
    }
}


#Preview {
    WreckSelector(wrecks: .constant([Wreck.test, Wreck.test, Wreck.test, Wreck.test, Wreck.test]))
}
