//
//  LoadingPanelView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.04.2023.
//

import SwiftUI

struct LoadingPanelView: View {
    var body: some View {
        HStack(spacing: 5) {
            ProgressView()
            Text("Loading...")
        }
        .padding()
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(radius: 10)
    }
}

struct LoadingPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.mint.ignoresSafeArea()
            LoadingPanelView()
        }
    }
}
