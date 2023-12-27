//
//  WreckTypePickerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckTypePickerView: View {
    
    @Binding var selection: WreckTypes?
    var enableAllCase: Bool
    
    var body: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $selection) {
                if enableAllCase {
                    Text("All")
                        .tag(WreckTypes?.none)
                    ForEach(WreckTypes.allCases) { type in
                        Text(type.description)
                            .tag(WreckTypes?.some(type))
                    }
                } else {
                    ForEach(WreckTypes.allCases) { type in
                        Text(type.description)
                            .tag(type)
                    }
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    WreckTypePickerView(selection: .constant(nil), enableAllCase: true)
}
