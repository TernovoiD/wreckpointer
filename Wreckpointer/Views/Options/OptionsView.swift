//
//  OptionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct OptionsView: View {
    @Binding var moderatorTab: Bool
    @State var approvedOnly: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                approvedWrecksMode
                moderatorMode
            }
            .navigationTitle("Options")
            .toolbar {
                Button(action: {}, label: {
                    Text("Credits")
                })
            }
        }
    }
    
    private var moderatorMode: some View {
        VStack(spacing: 5) {
            Toggle("Moderator Mode", isOn: $moderatorTab.animation(.easeInOut))
            Text("This function unlocks moderator functionality. Please note, moderator mode requires authorization. If you want to become moderator please write on email: wreckpointer@gmail.com")
                .font(.caption)
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 10)
            Divider()
        }
        .padding(.horizontal)
    }
    
    private var approvedWrecksMode: some View {
        VStack(spacing: 5) {
            Toggle("Approved wrecks", isOn: $approvedOnly.animation(.easeInOut))
            Text("This function hide all wrecks without approved checkmark. Unnaproved status is assigned to all newly created wrecks, wrecks that are pending or failed to pass the moderation.")
                .font(.caption)
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 10)
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    OptionsView(moderatorTab: .constant(true))
}
