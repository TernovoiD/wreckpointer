//
//  WidgetPlaceholder.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 08.01.2024.
//

import SwiftUI

enum WidgetSize {
    case small, medium, large
}

struct WidgetPlaceholder: View {
    
    let size: WidgetSize
    let color: Color
    
    var body: some View {
        switch size {
        case .small:
            smallPlaceholder
        case .medium:
            mediumPlaceholder
        case .large:
            largePlaceholder
        }
    }
    
    private var smallPlaceholder: some View {
        VStack {
            VStack(alignment: .trailing) {
                Text("Wreckpointer")
                    .font(.footnote.weight(.black))
                Text(".widget")
                    .font(.caption2.bold())
                    .foregroundStyle(color)
            }
            Spacer()
            Text("Get .PRO subscription to unlock widgets. Wreckpointer is a super unique and niche app which requires your support!")
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(Color.secondary)
        }
        .padding(15)
    }
    private var mediumPlaceholder: some View {
        VStack {
            VStack(alignment: .trailing) {
                Text("Wreckpointer")
                    .font(.headline.weight(.black))
                Text(".widget")
                    .font(.footnote.bold())
                    .foregroundStyle(color)
            }
            Spacer()
            Text("Get .PRO subscription to unlock widgets. Wreckpointer is a super unique and niche app which requires your support!")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.secondary)
        }
        .padding(15)
    }
    private var largePlaceholder: some View {
        VStack {
            VStack(alignment: .trailing) {
                Text("Wreckpointer")
                    .font(.largeTitle.weight(.black))
                Text(".widget")
                    .font(.title2.bold())
                    .foregroundStyle(color)
            }
            Spacer()
            Text("Get .PRO subscription to unlock widgets. Wreckpointer is a super unique and niche app which requires your support!")
                .font(.system(size: 25, weight: .regular))
                .foregroundStyle(Color.secondary)
                .padding()
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color.cyan
            .ignoresSafeArea()
        WidgetPlaceholder(size: .large, color: .accent)
//            .frame(maxWidth: 150, maxHeight: 150)
//                    .frame(maxHeight: 150)
                    .frame(maxHeight: 350)

            .background()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
    }
}
