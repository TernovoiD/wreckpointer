//
//  WreckCausePickerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckCausePickerView: View {
    
    @Binding var selection: WreckCauses?
    var enableAllCase: Bool
    
    var body: some View {
        HStack {
            Text("Cause")
            Spacer()
            Picker("Wreck cause", selection: $selection) {
                if enableAllCase {
                    Text("All")
                        .tag(WreckCauses?.none)
                    ForEach(WreckCauses.allCases) { cause in
                        Text(cause.description)
                            .tag(WreckCauses?.some(cause))
                    }
                } else {
                    ForEach(WreckCauses.allCases) { cause in
                        Text(cause.description)
                            .tag(cause)
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
    WreckCausePickerView(selection: .constant(nil), enableAllCase: true)
}
