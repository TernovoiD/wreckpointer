//
//  CoordinateTextField.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct CoordinateTextField: View {
    
    @Binding var value: String
    let placeholder: String
    let symbol: String
    
    var body: some View {
    }
}

#Preview {
    CoordinateTextField(value: .constant(""), placeholder: "51", symbol: "°")
}
