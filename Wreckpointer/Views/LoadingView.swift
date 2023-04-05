//
//  LoadingView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 03.04.2023.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("ship3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            VStack {
                Text("Wreckpointer")
                    .font(.largeTitle.weight(.black))
                    .shadow(radius: 10)
                ProgressView()
            }
        }
        .statusBar(hidden: true)
        .background()
        .ignoresSafeArea()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

// MARK: Content

extension LoadingView {
    
//    var loadingPlate: some View {
//        HStack(spacing: 10) {
////            Text(wreckpointeDescription)
//            ProgressView()
//            Text("Loading...")
//        }
//        .padding()
//        .background()
//        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
//        .shadow(radius: 10)
//    }
}
