//
//  OptionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 29.12.2023.
//

import SwiftUI
import WidgetKit

struct OptionsView: View {
    
    @AppStorage("hideUnapprovedWrecks",store: UserDefaults(suiteName: "group.MWQ8P93RWJ.com.danyloternovoi.Wreckpointer"))
    var hideUnapprovedWrecks: Bool = false
    
    @Binding var showModeratorPage: Bool
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Toggle("Hide unapproved", isOn: $hideUnapprovedWrecks)
                    Text("This option will hide all wrecks that moderators have not yet checked. All newly created and created by AI wrecks receive unapproved status.")
                        .font(.caption2)
                        .fontWeight(.light)
                        .foregroundStyle(Color.secondary)
                        .padding(.top, 5)
                }
                VStack(alignment: .leading) {
                    Toggle("Moderator mode", isOn: $showModeratorPage)
                    Text("This option activates the moderator mode. Please note, that this mode requires authorisation. Contact wreckpointer@gmail.com to get a moderator account.")
                        .font(.caption2)
                        .fontWeight(.light)
                        .foregroundStyle(Color.secondary)
                        .padding(.top, 5)
                }
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
