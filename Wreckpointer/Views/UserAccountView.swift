//
//  UserAccountView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.08.2023.
//

import SwiftUI

struct UserAccountView: View {
    
    @StateObject var viewModel = AccountViewModel()
    @EnvironmentObject var state: AppState
    @State var showConfirmation: Bool = false
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    AccountUpdateView(user: $state.authorizedUser,
                                      bio: state.authorizedUser?.bio ?? "",
                                      image: state.authorizedUser?.image)
                } label: {
                    header
                }
            }
            if let info = state.authorizedUser?.bio {
                Section("Info") {
                    Text(info)
                }
            }
            Section("Settings") {
                if isNotModerator { changePasswordButton }
                signOutButton
                if isNotModerator { deleteAccountButton }
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .confirmationDialog("Are you sure?", isPresented: $showConfirmation) {
            confirmAccountDeleteButton
        } message: {
            Text("You cannot undo this action")
        }

    }
    
    var isNotModerator: Bool {
        state.authorizedUser?.role != "moderator"
    }
    
    private func deleteAccount() async {
        if let user = state.authorizedUser {
            let result = await viewModel.deleteAccount(forUser: user)
            if result {
                withAnimation(.easeInOut) {
                    viewModel.signOut()
                    state.authorizedUser = nil
                }
            }
        }
    }
}

struct UserAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountView()
            .environmentObject(AccountViewModel())
            .environmentObject(AppState())
    }
}


// MARK: - Variables

extension UserAccountView {
    
    var header: some View {
        HStack(alignment: .top) {
            accountImage
                .padding(.trailing)
            VStack(alignment: .leading, spacing: 5) {
                Text(state.authorizedUser?.username ?? "Unknown")
                    .font(.title.weight(.bold))
                Text("Created: \(state.authorizedUser?.createdAt?.formatted(date: .numeric, time: .omitted) ?? Date().formatted(date: .long, time: .omitted))")
                    .font(.headline)
                Text(state.authorizedUser?.email ?? "")
                    .font(.headline)
            }
            Spacer()
        }
    }
    
    var accountImage: some View {
        VStack {
            if let image = state.authorizedUser?.image,
               let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        .frame(maxWidth: 80)
        .clipShape(Circle())
        .background(Circle().stroke(lineWidth: 3).foregroundColor(.accentColor))
    }
    
    var updateButton: some View {
        NavigationLink {
            Text("Update")
        } label: {
            Text("Update")
            Image(systemName: "pencil.circle")
        }
    }
    
    var changePasswordButton: some View {
        NavigationLink {
            ChangePasswordView()
        } label: {
            Label("Change password", systemImage: "lock.rectangle.fill")
                .foregroundColor(.primary)
        }
    }
    
    var signOutButton: some View {
        Button(role: .none) {
            withAnimation(.easeInOut) {
                viewModel.signOut()
                state.authorizedUser = nil
            }
        } label: {
            Label("Sign Out", systemImage: "person.crop.rectangle.fill")
                .foregroundColor(.primary)
        }
    }
    
    var deleteAccountButton: some View {
        Button(role: .destructive) {
            showConfirmation = true
        } label: {
            Label("Delete my account", systemImage: "trash.fill")
                .foregroundColor(.red)
        }
    }
    
    var confirmAccountDeleteButton: some View {
        Button(role: .destructive) {
            Task { await deleteAccount() }
        } label: {
            Label("Delete my account", systemImage: "trash.fill")
                .foregroundColor(.red)
        }
    }
}

