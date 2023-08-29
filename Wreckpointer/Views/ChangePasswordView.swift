//
//  ChangePasswordView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @FocusState private var selectedField: FocusText?
    @StateObject private var viewModel = ChangePasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    
    var validForm: Bool {
        if oldPassword.isEmpty || newPassword.isEmpty {
            viewModel.showError(withMessage: "Fields cannot be empty.")
            return false
        } else if !newPassword.isValidPassword {
            viewModel.showError(withMessage: "New password must contain at least 6 characters.")
            return false
        } else {
            return true
        }
    }
    
    enum FocusText {
        case oldPassword
        case newPassword
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                oldPasswordField
                newPasswordField
            }
        }
        .toolbar{ saveButton }
        .navigationTitle("Change password")
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .onTapGesture {
            selectedField = .none
        }
    }
    
    private func getPassChange() -> User? {
        if validForm {
            return User(password: oldPassword,
                        newPassword: newPassword,
                        newPasswordConfirm: newPassword)
        } else { return nil }
    }
    
    private func changePassword(forUser user: User) {
        Task {
            if await viewModel.changePassword(forUser: user) {
                dismiss()
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangePasswordView()
                .environmentObject(ChangePasswordViewModel())
        }
    }
}


// MARK: - Variables

extension ChangePasswordView {
    
    var oldPasswordField: some View {
        SecureField("Password", text: $oldPassword)
            .padding()
            .focused($selectedField, equals: .oldPassword)
            .neonField(light: selectedField == .oldPassword ? true : false)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .oldPassword
            }
            .onSubmit {
                selectedField = .newPassword
            }
            .padding(.horizontal)
    }
    
    var newPasswordField: some View {
        SecureField("New password", text: $newPassword)
            .padding()
            .focused($selectedField, equals: .newPassword)
            .neonField(light: selectedField == .newPassword ? true : false)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textContentType(.newPassword)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .newPassword
            }
            .onSubmit {
                selectedField = .none
            }
            .padding(.horizontal)
    }
    
    var saveButton: some View {
        Button {
            if let user = getPassChange() {
                Task { changePassword(forUser: user)}
            }
        } label: {
            Text("Save")
                .font(.headline)
        }
    }
}
