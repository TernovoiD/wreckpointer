//
//  SearchList.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct SearchList: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appData: AppData
    @State private var searchText: String = ""
     
    var body: some View {
        List {
            ForEach(filteredWrecks) { wreck in
                Button {
                    select(wreck: wreck)
                } label: {
                    SearchListRow(wreck: wreck)
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .background(.ultraThinMaterial)
        .frame(maxHeight: appData.textToSearch.isEmpty || appData.wrecksFiltered.count == 0 ? 0 : 200)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal)
    }
    
    private func select(wreck: Wreck) {
        withAnimation(.easeInOut) {
            appState.select(wreck: wreck)
            appData.textToSearch = ""
        }
    }
    
    private var filteredWrecks: [Wreck] {
        return appData.wrecks.filter({ $0.title.lowercased().contains(appData.textToSearch.lowercased()) })
    }
}

struct SearchListRow: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        HStack {
            ImageView(imageData: $wreck.image)
                .frame(maxWidth: 40, maxHeight: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            VStack(alignment: .leading, spacing: 0) {
                Text(wreck.title)
                    .font(.headline.weight(.bold))
                Text("Date of loss: \(wreck.dateOfLoss?.formatted(date: .abbreviated, time: .omitted) ?? "unknown")")
                    .font(.subheadline.weight(.semibold))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .bold()
                .foregroundColor(.accentColor)
        }
    }
}

struct SearchList_Previews: PreviewProvider {
    static var previews: some View {
        SearchListRow(wreck: Wreck.test)
            .environmentObject(AppState())
            .environmentObject(AppData())
            .padding()
            .background(Color.gray.opacity(0.15))
    }
}
