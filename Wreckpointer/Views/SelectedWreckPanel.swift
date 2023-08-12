//
//  SelectedWreckPanel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.08.2023.
//

import SwiftUI

struct SelectedWreckPanel: View {
    
    @StateObject var viewModel = SelectedWreckViewModel()
    @EnvironmentObject var wrecks: Wrecks
    @EnvironmentObject var state: AppState
    @State var wreck: Wreck
    @State var showWreck: Wreck?
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                characteristics
                Spacer()
                VStack {
                    moreButton
                    editButton
                        .disabled(state.authorizedUser == nil ? true : false)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 150)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .overlay { image }
        .padding(.horizontal)
        .shadow(radius: 10)
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .sheet(item: $showWreck, content: { wreck in
            WreckDetailedView(wreck: wreck)
        })
        .onChange(of: wrecks.selectedWreck, perform: { newValue in
            if let wreck = newValue {
                withAnimation(.easeInOut) {
                    self.wreck = wreck
                }
            }
        })
    }
    
    private func deleteWreck() {
        Task {
            let result = await viewModel.delete(wreck: wreck)
            if result {
                wrecks.selectedWreck = nil
            }
        }
    }
}

struct SelectedWreckPanel_Previews: PreviewProvider {
    static var previews: some View {
        let wreck = Wreck(cause: "other", type: "all", title: "Titanic", latitude: 41, longitude: -49, wreckDive: false)
        SelectedWreckPanel(wreck: wreck)
            .environmentObject(Wrecks())
            .environmentObject(SelectedWreckViewModel())
            .environmentObject(AppState())
    }
}

// MARK: - Variables

extension SelectedWreckPanel {
    
    var characteristics: some View {
        VStack(alignment: .leading) {
            Text("Name: \(wreck.title)")
            Text("Latitude: \(abs(wreck.latitude), specifier: "%.2F") \(wreck.latitude >= 0 ? "N" : "S")")
            Text("Longitude: \(abs(wreck.longitude), specifier: "%.2F") \(wreck.longitude >= 0 ? "E" : "W")")
        }
        .font(.headline)
        .padding(.leading)
    }
    
    var image: some View {
        HStack {
            ImageView(imageData: $wreck.image)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .offset(y: -80)
                .shadow(radius: 10)
                .padding(.leading)
            Spacer()
        }
        .padding()
    }
    
    var moreButton: some View {
        Button {
            showWreck = wreck
        } label: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(maxWidth: 10)
                Text("More")
            }
            .padding()
            .font(.headline)
            .frame(maxWidth: 150)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 5)
        }
    }
    
    var editButton: some View {
        NavigationLink {
            AddUpdateWreck(wreck: wreck)
        } label: {
            HStack {
                Image(systemName: "pencil")
                    .frame(maxWidth: 10)
                Text("Edit")
            }
            .padding()
            .font(.headline)
            .frame(maxWidth: 150)
            .foregroundColor(.white)
            .background(state.authorizedUser == nil ? Color.gray : Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 5)
            .contextMenu {
                Button(role: .destructive) {
                    deleteWreck()
                } label: {
                    Label("Delete", systemImage: "trash.circle")
                }

            }
        }
    }
}
