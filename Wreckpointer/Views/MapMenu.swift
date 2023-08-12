//
//  MapMenu.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapMenu: View {
    
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openCloseMenuButton
            if state.activeUIElement == .mapMenu {
                Divider()
                    .frame(maxWidth: 120)
                accountButton
                addWreckButton
            }
        }
        .font(.headline)
        .padding()
        .accentColorBorder()
    }
    
    var openCloseMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                state.activeUIElement = state.activeUIElement == .mapMenu ? .none : .mapMenu
            }
        } label: {
            if state.activeUIElement == .mapMenu {
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
    
    var accountButton: some View {
        NavigationLink {
            AccountView()
        } label: {
            HStack {
                Image(systemName: "person.crop.rectangle")
                    .frame(maxWidth: 20)
                Text("Account")
            }
        }
    }
    
    var addWreckButton: some View {
        NavigationLink {
            AddUpdateWreck(wreck: Wreck())
        } label: {
            HStack {
                Image(systemName: "plus.rectangle")
                    .frame(maxWidth: 20)
                Text("Add Wreck")
            }
            .frame(maxWidth: 140, alignment: .leading)
        }
        .disabled(state.authorizedUser == nil ? true : false)
    }
}

struct MapMenu_Previews: PreviewProvider {
    static var previews: some View {
        MapMenu()
            .environmentObject(AppState())
    }
}
