//
//  SupportWidgetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import SwiftUI

struct SupportWidgetView: View {
    
    let description: String
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .trailing) {
                Text("Wreckpointer")
                    .font(.largeTitle.weight(.black))
                Text(".project")
                    .foregroundStyle(Color.indigo)
            }
            .font(.title2.bold())
            Text(description)
                .font(.callout.bold())
                .foregroundStyle(Color.secondary)
        }
    }
}

#Preview {
    SupportWidgetView(description: "")
}
