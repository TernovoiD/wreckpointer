//
//  WreckAdditionalInfoPlate.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckAdditionalInfoPlate: View {
    
    @Binding var depth: String
    @Binding var deadweight: String
    @Binding var lossOfLife: String
    
    var body: some View {
        VStack {
            TextField("Depth", text: $depth)
                .padding(10)
                .coloredBorder(color: .gray)
            TextField("Deadweight", text: $depth)
                .padding(10)
                .coloredBorder(color: .gray)
            TextField("Loss of Life", text: $depth)
                .padding(10)
                .coloredBorder(color: .gray)
        }
        .padding()
    }
}

#Preview {
    WreckAdditionalInfoPlate(depth: .constant(""), deadweight: .constant(""), lossOfLife: .constant(""))
}
