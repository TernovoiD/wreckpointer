//
//  NeonTextFieldModifier.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct NeonTextFieldModifier: ViewModifier {
    var light: Bool
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(lineWidth: 3)
                    .foregroundStyle(
                        .linearGradient(colors: light ? [.purple, .green] : [.gray.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            )
            .background(.ultraThinMaterial)
            .mask(RoundedRectangle(cornerRadius: 15))
            .shadow(color: light ? .cyan : .white,
                    radius: light ? 7 : 1)
    }
}

extension View {
    func neonField(light: Bool) -> some View {
        self.modifier(NeonTextFieldModifier(light: light))
    }
}
