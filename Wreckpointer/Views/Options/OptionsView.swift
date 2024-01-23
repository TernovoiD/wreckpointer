//
//  OptionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 29.12.2023.
//

import SwiftUI
import WidgetKit
import StoreKit

struct OptionsView: View {
    
    @AppStorage("hideUnapprovedWrecks",store: UserDefaults(suiteName: "group.MWQ8P93RWJ.com.danyloternovoi.Wreckpointer"))
    var hideUnapprovedWrecks: Bool = false
    
    @Binding var showModeratorPage: Bool
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    hideUnapprovedSwitch
                    moderatorModeSwitch
                    resetPurchasesButton
                }
                .padding(.horizontal)
            }
            .navigationTitle("Options")
            .toolbar {
                ToolbarItem {
                    NavigationLink("About") {
                        AboutView()
                    }
                    .font(.headline.bold())
                }
            }
        }
    }
}

#Preview {
    OptionsView(showModeratorPage: .constant(false))
}

private extension OptionsView {
    
    var hideUnapprovedSwitch: some View {
        VStack(alignment: .leading) {
            Toggle("Hide unapproved", isOn: $hideUnapprovedWrecks)
                .font(.headline)
            Text("This option will hide all wrecks that moderators have not yet checked. All newly created and created by AI wrecks receive unapproved status.")
                .font(.caption2)
                .fontWeight(.light)
                .foregroundStyle(Color.secondary)
                .padding(.top, 5)
        }
    }
    
    var moderatorModeSwitch: some View {
        VStack(alignment: .leading) {
            Toggle("Moderator mode", isOn: $showModeratorPage)
                .font(.headline)
            Text("This option activates the moderator mode. Please note, that this mode requires authorisation. Contact wreckpointer@gmail.com to get a moderator account.")
                .font(.caption2)
                .fontWeight(.light)
                .foregroundStyle(Color.secondary)
                .padding(.top, 5)
        }
    }
    
    var resetPurchasesButton: some View {
        Button(action: {
            Task {
                try? await AppStore.sync()
            }
        }, label: {
            Color.clear
                .frame(height: 50)
                .overlay {
                    Text("Restore Purchases")
                        .font(.headline)
                }
                .coloredBorder(color: .accent)
        })
    }
    
}
