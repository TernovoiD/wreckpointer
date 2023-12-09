//
//  WreckTypePickerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckTypePickerView: View {
    
    @Binding var selection: WreckTypes
    
    var body: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $selection) {
                ForEach(WreckTypes.allCases) { option in
                    Text(String(describing: option).capitalized)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    WreckTypePickerView(selection: .constant(.unknown))
}
