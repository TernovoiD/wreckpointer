//
//  ColoredBorder.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 08.12.2023.
//

import SwiftUI

struct ColoredBorderModifier: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(color)
            )
            .background()
            .mask(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func coloredBorder(color: Color) -> some View {
        self.modifier(ColoredBorderModifier(color: color))
    }
}
