//
//  AccountMenu.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct AccountMenu: View {
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State var openAccountMenu: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openCloseMenuButton
            if openAccountMenu {
                Divider()
                    .frame(maxWidth: 100)
                editBioButton
                changeImageButton
                changePasswordButton
                signOutButton
                Divider()
                    .frame(maxWidth: 100)
                deleteAccountButton
            }
        }
        .font(.headline)
        .padding()
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(lineWidth: 3))
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .foregroundColor(.purple)
        .padding()
    }
    
    var openCloseMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openAccountMenu.toggle()
            }
        } label: {
            if openAccountMenu {
                Label("Close", systemImage: "xmark")
            } else {
                Image(systemName: "gear")
                    .font(.title2)
                    .bold()
            }
        }
    }
    
    var editBioButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openAccountMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "person.text.rectangle")
                    .frame(maxWidth: 20)
                Text("Edit bio")
            }
        }
    }
    
    var changeImageButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openAccountMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "photo")
                    .frame(maxWidth: 20)
                Text("Change image")
            }
        }
    }
    
    var changePasswordButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openAccountMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "lock.rectangle")
                    .frame(maxWidth: 20)
                Text("Change password")
            }
        }
    }
    
    var signOutButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openAccountMenu = false
                authVM.signOut()
            }
        } label: {
            HStack {
                Image(systemName: "person.crop.rectangle")
                    .frame(maxWidth: 20)
                Text("Sign Out")
            }
        }
    }
    
    var deleteAccountButton: some View {
        Button {
            withAnimation(.easeInOut) {
                openAccountMenu = false
                deleteAccount()
            }
        } label: {
            HStack {
                Image(systemName: "trash.square")
                    .frame(maxWidth: 20)
                Text("Delete my account")
            }
            .foregroundColor(.red)
        }
    }
    
    private func deleteAccount() {
        Task {
            do {
                try await authVM.deleteAccount()
                authVM.signOut()
            } catch let error {
                print(error)
            }
        }
    }
}

struct AccountMenu_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        // Init View model
        let authViewModel = AuthenticationViewModel(userService: userService)
        
        AccountMenu()
            .environmentObject(authViewModel)
    }
}
