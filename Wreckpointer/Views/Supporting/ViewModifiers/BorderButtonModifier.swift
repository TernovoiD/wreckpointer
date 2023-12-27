//
//  BorderButtonModifier.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct AccentColorBorderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(lineWidth: 3))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .foregroundColor(.accentColor)
    }
}

extension View {
    func accentColorBorder() -> some View {
        self.modifier(AccentColorBorderModifier())
    }
}
