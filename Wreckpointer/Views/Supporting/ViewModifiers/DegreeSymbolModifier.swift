//
//  DegreeSymbolModifier.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct DegreeSymbolModifier: ViewModifier {
    
    var symbol: String
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 30)
            .padding(5)
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Text(symbol)
                    }
                    Spacer()
                }
            }
    }
}

extension View {
    func degree(symbol: String) -> some View {
        self.modifier(DegreeSymbolModifier(symbol: symbol))
    }
}
