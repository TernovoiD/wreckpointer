//
//  WreckSelectorsPlate.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckSelectorsPlate: View {
    
    @Binding var type: WreckTypes
    @Binding var cause: WreckCauses
    @Binding var isWreckDive: Bool
    @Binding var dateOfLoss: Date
    
    var body: some View {
        VStack {
            DatePicker("Date", selection: $dateOfLoss, displayedComponents: .date)
                .datePickerStyle(.compact)
//            WreckTypePickerView(selection: $type)
//            WreckCausePickerView(selection: $cause)
            Toggle("Wreck dive", isOn: $isWreckDive)
        }
        .padding()
    }
    
}

#Preview {
    WreckSelectorsPlate(type: .constant(.unknown), cause: .constant(.unknown), isWreckDive: .constant(true), dateOfLoss: .constant(Date()))
}
