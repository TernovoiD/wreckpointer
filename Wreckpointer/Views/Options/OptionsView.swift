//
//  OptionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 29.12.2023.
//

import SwiftUI
import WidgetKit

struct OptionsView: View {
    
    @Binding var showModeratorPage: Bool
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Toggle("Moderator mode", isOn: $showModeratorPage)
                    Text("This option activates moderator functional. Please not, this functional requires authorization. Contact danyloternovoi@gmail.com to get moderator account.")
                        .font(.caption2)
                        .fontWeight(.light)
                        .foregroundStyle(Color.secondary)
                }
                VStack(alignment: .leading) {
                    Toggle("Approved only", isOn: $showModeratorPage)
                    Text("This option will hide all unapproved wrecks. Unnaproved status is assigned to all newly created wrecks, wrecks which are pending for moderator check or failed it")
                        .font(.caption2)
                        .fontWeight(.light)
                        .foregroundStyle(Color.secondary)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: { }, label: {
                        Text("Credits")
                    })
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reload widget") {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
            }
            .navigationTitle("Options")
        }
    }
}

#Preview {
    OptionsView(showModeratorPage: .constant(true))
}
