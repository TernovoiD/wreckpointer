//
//  SelectedWreckPanel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.08.2023.
//

import SwiftUI

//struct SelectedWreckPanel: View {
//    
//    @AppStorage("showFeetUnits") private var showFeetUnits: Bool = true
//    @EnvironmentObject private var appState: AppState
//    @EnvironmentObject private var appData: AppData
//    @StateObject private var viewModel = SelectedWreckViewModel()
//    @State private var wreckToShow: Wreck?
//    
//    var body: some View {
//        VStack {
//            HStack(alignment: .bottom) {
//                image
//                Spacer()
//                VStack {
//                    if appState.authorizedUser == appState.selectedWreck?.creator || appState.authorizedUser?.role == "moderator" || appState.selectedWreck?.creator == nil {
//                        editButton
//                    }
//                    if appState.authorizedUser == appState.selectedWreck?.creator || appState.authorizedUser?.role == "moderator" {
//                        deleteButton
//                    }
//                    moreButton
//                    hideButton
//                }
//                .padding(10)
//            }
//        }
//        .frame(maxHeight: 200)
//        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(lineWidth: 5))
//        .background(.ultraThinMaterial)
//        .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
//        .padding(.horizontal)
//        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
//            Button("OK", role: .cancel) { }
//        }
//        .sheet(item: $wreckToShow, content: { wreck in
//            WreckDetailedView(wreck: wreck)
//        })
//    }
//    
//    private func delete() async {
//        if let wreck = appState.selectedWreck {
//            let result = await viewModel.delete(wreck: wreck)
//            if result {
//                appData.wrecks.removeAll(where: { $0 == wreck })
//                appState.activate(element: .none)
//                appState.select(wreck: nil)
//            }
//        }
//    }
//}

//struct SelectedWreckPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedWreckPanel()
//            .environmentObject(SelectedWreckViewModel())
//            .environmentObject(AppState())
//            .environmentObject(AppData())
//    }
//}



// MARK: - Variables

//extension SelectedWreckPanel {
//    
//    var characteristics: some View {
//        VStack(alignment: .leading) {
//            if let wreck = appState.selectedWreck {
//                Spacer()
//                Text("Name: \(wreck.title)")
//                Text("Latitude: \(abs(wreck.latitude), specifier: "%.2F") \(wreck.latitude >= 0 ? "N" : "S")")
//                Text("Longitude: \(abs(wreck.longitude), specifier: "%.2F") \(wreck.longitude >= 0 ? "E" : "W")")
//            }
//        }
//        .foregroundColor(.white)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .font(.subheadline.weight(.bold))
//        .shadow(color: .black, radius: 3)
//        .padding(10)
//    }
//    
//    var image: some View {
//        ImageView(imageData: .constant(appState.selectedWreck?.image))
//            .frame(maxWidth: 250)
//            .frame(maxHeight: 200)
//            .overlay(content: { characteristics })
//            .clipped()
//            
//    }
//    
//    var moreButton: some View {
//        Button {
//            wreckToShow = appState.selectedWreck
//        } label: {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .frame(maxWidth: 10)
//                Text("More")
//            }
//            .padding(.horizontal)
//            .font(.headline)
//            .frame(minWidth: 120, maxHeight: .infinity)
//            .foregroundColor(.white)
//            .background(Color.accentColor)
//            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
//        }
//    }
//    
//    var editButton: some View {
//        NavigationLink {
//            if let wreck = appState.selectedWreck {
//                let depth = showFeetUnits ? wreck.depth?.metersToFeet ?? 0 : wreck.depth ?? 0
//                AddUpdateWreck(wreck: wreck,
//                               wreckDive: wreck.wreckDive,
//                               image: wreck.image,
//                               title: wreck.title,
//                               latitude: String(abs(wreck.latitude)),
//                               longitude: String(abs(wreck.longitude)),
//                               northLatitude: wreck.latitude >= 0 ? true : false,
//                               eastLongitude: wreck.longitude >= 0 ? true : false,
//                               feetUnits: showFeetUnits ? true : false,
//                               depth: String(format: "%.2f", depth),
//                               type: WreckTypesEnum.allCases.first(where: { $0.rawValue == wreck.type }) ?? WreckTypesEnum.unknown,
//                               cause: WreckCausesEnum.allCases.first(where: { $0.rawValue == wreck.cause }) ?? WreckCausesEnum.unknown,
//                               dateOfLoss: wreck.dateOfLoss ?? Date(),
//                               dateOfLossKnown: wreck.dateOfLoss == nil ? false : true,
//                               description: wreck.information ?? "")
//            }
//        } label: {
//            HStack {
//                Image(systemName: "pencil")
//                    .frame(maxWidth: 10)
//                Text("Edit")
//            }
//            .padding(.horizontal)
//            .font(.headline)
//            .frame(minWidth: 120, maxHeight: .infinity)
//            .foregroundColor(.white)
//            .background(Color.orange)
//            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
//            .contextMenu {
//                Button(role: .destructive) { Task { await delete() }
//                } label: {
//                    Label("Delete", systemImage: "trash.circle")
//                }
//
//            }
//        }
//    }
//    
//    var deleteButton: some View {
//        Button {
//            Task { await delete() }
//        } label: {
//            HStack {
//                Image(systemName: "trash")
//                    .frame(maxWidth: 10)
//                Text("Delete")
//            }
//            .padding(.horizontal)
//            .font(.headline)
//            .frame(minWidth: 120, maxHeight: .infinity)
//            .foregroundColor(.white)
//            .background(Color.red)
//            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
//        }
//    }
//    
//    var hideButton: some View {
//        Button {
//            withAnimation(.easeInOut) {
//                appState.select(wreck: nil)
//                appState.activate(element: .none)
//            }
//        } label: {
//            HStack {
//                Image(systemName: "xmark")
//                    .frame(maxWidth: 10)
//                Text("Hide")
//            }
//            .padding(.horizontal)
//            .font(.headline)
//            .frame(minWidth: 120, maxHeight: .infinity)
//            .foregroundColor(.white)
//            .background(Color.indigo)
//            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
//        }
//    }
//}
