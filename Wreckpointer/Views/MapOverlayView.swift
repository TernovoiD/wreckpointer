//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @State var searchText: String = ""
    @State var openMenu: Bool = false
    @State var openFilter: Bool = false
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding()
                .neonField(light: true)
            HStack {
                Spacer()
                menu
            }
            .padding(.horizontal)
            Spacer()
            filterMenu
        }
        .padding()
    }
}

struct MapOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        MapOverlayView()
            .background(Color.green)
    }
}

    // MARK: - Filter

extension MapOverlayView {
    var filterMenu: some View {
        VStack {
            openFilterMenuButton
            if openFilter {
                Circle()
            }
        }
        .font(.headline)
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(.indigo)
        .offset(y: -20)
    }
    
    var openFilterMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openFilter.toggle()
            }
        } label: {
            if openFilter {
                Label("Close", systemImage: "xmark")
            } else {
                Label("Filter", systemImage: "plus")
            }
        }
    }
}


    // MARK: - Menu

extension MapOverlayView {
    var menu: some View {
        VStack(alignment: .leading, spacing: 10) {
            openCloseMenuButton
            if openMenu {
                Divider()
                    .frame(maxWidth: 100)
                accountButton
                settingsButton
                addWreckButton
                Divider()
                    .frame(maxWidth: 100)
            }
        }
        .font(.headline)
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .frame(maxWidth: .infinity, alignment: .trailing)
        .foregroundColor(.indigo)
    }
    
    var openCloseMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openMenu.toggle()
            }
        } label: {
            if openMenu {
                Label("Close", systemImage: "xmark")
            } else {
                Image(systemName: "text.justify")
                    .font(.title2)
                    .bold()
            }
        }
    }
    
    var settingsButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "gear")
                    .frame(maxWidth: 20)
                Text("Settings")
            }
        }
    }
    
    var accountButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "person")
                    .frame(maxWidth: 20)
                Text("Account")
            }
        }
    }
    
    var addWreckButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "plus")
                    .frame(maxWidth: 20)
                Text("Add Wreck")
            }
        }
    }
}
