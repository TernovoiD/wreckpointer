//
//  WreckCausePickerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckCausePickerView: View {
    
    @Binding var selection: WreckCauses
    
    var body: some View {
        HStack {
            Text("Cause")
            Spacer()
            Picker("Wreck cause", selection: $selection) {
                ForEach(WreckCauses.allCases) { option in
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
    WreckCausePickerView(selection: .constant(.unknown))
}
