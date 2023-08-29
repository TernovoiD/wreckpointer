//
//  MapMenu.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapMenu: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openCloseMenuButton
            if appState.activeUIElement == .mapMenu {
                Divider()
                    .frame(maxWidth: 120)
                if appState.authorizedUser == nil {
                    loginButton
                } else {
                    accountButton
                }
                addWreckButton
                    .disabled(appState.authorizedUser == nil ? true : false)
            }
        }
        .font(.headline)
        .padding()
        .accentColorBorder()
    }
}

struct MapMenu_Previews: PreviewProvider {
    static var previews: some View {
        MapMenu()
            .environmentObject(AppState())
            .environmentObject(AppData())
    }
}


// MARK: - Variables

extension MapMenu {
    
    private var openCloseMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                appState.activate(element: appState.activeUIElement == .mapMenu ? .none : .mapMenu)
            }
        } label: {
            if appState.activeUIElement == .mapMenu {
                Label("Menu", systemImage: "xmark")
            } else {
                Image(systemName: "text.justify")
                    .frame(width: 35, height: 35)
                    .font(.title2)
                    .bold()
                    .rotationEffect(Angle(degrees: 90))
            }
        }
    }
    
    private var loginButton: some View {
        NavigationLink {
            LoginView()
        } label: {
            HStack {
                Image(systemName: "person.crop.rectangle")
                    .frame(maxWidth: 20)
                Text("Login")
            }
        }
    }
    
    private var accountButton: some View {
        NavigationLink {
            UserAccountView()
        } label: {
            HStack {
                Image(systemName: "person.crop.rectangle")
                    .frame(maxWidth: 20)
                Text("My account")
            }
        }
    }
    
    private var addWreckButton: some View {
        NavigationLink {
            AddUpdateWreck(wreck: nil)
        } label: {
            HStack {
                Image(systemName: "plus.rectangle")
                    .frame(maxWidth: 20)
                Text("Add Wreck")
            }
            .frame(maxWidth: 140, alignment: .leading)
        }
        .disabled(appState.activeUIElement == nil ? true : false)
    }
}
