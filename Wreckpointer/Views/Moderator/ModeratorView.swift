//
//  ModeratorView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 29.12.2023.
//

import SwiftUI

struct ModeratorView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink { 
                    Text("Created wrecks")
                } label: {
                    Label("Newly created wrecks", systemImage: "calendar.badge.plus")
                }
                NavigationLink {
                    Text("Unapproved wrecks")
                } label: {
                    Label("Unapproved wrecks", systemImage: "checkmark.circle.badge.xmark")
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        Text("Moderator access")
                    } label: {
                        Text("Access")
                    }
                }
            }
            .navigationTitle("Moderator")
        }
    }
}

#Preview {
    ModeratorView()
}
