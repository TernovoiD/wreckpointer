//
//  WrecksListView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.07.2023.
//

import SwiftUI

struct WrecksListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appData: AppData
    @State var searchText: String = ""
    @Binding var wreck: Wreck?
    
    var body: some View {
        List {
            ForEach(searchResults) { wreck in
                SearchListRow(wreck: wreck)
                    .onTapGesture {
                        self.wreck = wreck
                        dismiss()
                    }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Wrecks")
    }
    
    var searchResults: [Wreck] {
        if searchText.isEmpty {
            return appData.wrecks
        } else {
            return appData.wrecks.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
        }
    }
}

struct WrecksListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WrecksListView(wreck: .constant(nil))
                .environmentObject(AppData())
        }
    }
}
