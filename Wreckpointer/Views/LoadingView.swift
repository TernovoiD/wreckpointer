//
//  LoadingView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.08.2023.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var show: Bool
    @State private var showHeader: Bool = true
    @State private var showDescription: Bool = true
    @State private var showProgress: Bool = true
    @State private var showPicture: Bool = true
    @State private var showBackground: Bool = true

    
    var body: some View {
        ZStack {
            if showBackground {
                Color.clear.background(.ultraThinMaterial)
            }
            VStack {
                Spacer()
                if showPicture {
                    image
                }
            }
            VStack {
                Text("Wreckpointer")
                    .font(.system(size: showPicture ? 35 : 45, weight: .black, design: .serif))
                    .foregroundColor(showPicture ? .primary : .accentColor)
                    .offset(y: showHeader ? 0 : -1000)
                Text("Shipwrecks interactive map")
                    .font(.subheadline.weight(.black))
                    .offset(y: showDescription ? 0 : -1000)
                if showProgress {
                    ProgressView()
                        .scaleEffect(1.8)
                        .padding(.top)
                }
                Spacer()
            }
            .padding(.top, 200)
            .onChange(of: show) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    presentApp()
                }
            }
        }
    }
    
    private func presentApp() {
        withAnimation(.easeInOut) {
            withAnimation(.easeInOut) {
                showProgress = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut) {
                    showPicture = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut) {
                    showHeader = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut) {
                    showDescription = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut) {
                    showBackground = false
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.indigo.ignoresSafeArea()
            LoadingView(show: .constant(true))
        }
    }
}


// MARK: - Variables

extension LoadingView {
    
    private var image: some View {
        Image("ship3")
            .resizable()
            .frame(maxHeight: 300)
            .aspectRatio(0.5, contentMode: .fill)
            .ignoresSafeArea(.keyboard)
    }
    
    
}
