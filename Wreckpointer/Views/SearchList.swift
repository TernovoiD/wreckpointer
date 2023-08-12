//
//  SearchList.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct SearchList: View {
    
    @EnvironmentObject var wrecks: Wrecks
    @EnvironmentObject var state: AppState
    
    var body: some View {
        List {
            ForEach(wrecks.filteredByText) { wreck in
                Button {
                    withAnimation(.easeInOut) {
                        wrecks.selectedWreck = wreck
                    }
                } label: {
                    SearchListRow(wreck: wreck)
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .background(.ultraThinMaterial)
        .frame(maxHeight: 200)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct SearchListRow: View {
    
    @State var wreck: Wreck
    
    var body: some View {
        HStack {
            ImageView(imageData: $wreck.image)
                .frame(maxWidth: 40)
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
        let wreck = Wreck(cause: "", type: "", title: "Bismarck", latitude: 0, longitude: 0, wreckDive: false, dateOfLoss: Date())
        SearchListRow(wreck: wreck)
            .environmentObject(Wrecks())
            .environmentObject(AppState())
            .padding()
            .background(Color.gray.opacity(0.15))
    }
}
