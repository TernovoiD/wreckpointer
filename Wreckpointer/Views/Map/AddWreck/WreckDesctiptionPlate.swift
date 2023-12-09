//
//  WreckDesctiptionPlate.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckDesctiptionPlate: View {
    
    @Binding var description: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Wreck description:")
                Spacer()
            }
            TextEditor(text: $description)
                .frame(maxHeight: 100)
                .padding(10)
                .coloredBorder(color: .gray)
        }
        .padding()
    }
}

#Preview {
    WreckDesctiptionPlate(description: .constant(""))
}
