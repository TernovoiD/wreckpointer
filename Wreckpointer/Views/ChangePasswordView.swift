//
//  ChangePasswordView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @FocusState var selectedField: FocusText?
    @StateObject var viewModel = ChangePasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    enum FocusText {
        case oldPassword
        case newPassword
        case newPasswordConfirmation
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                oldPasswordField
                newPasswordField
                newPasswordConfirmationField
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
    
    private func changePassword() {
        Task {
            await viewModel.changePassword()
            dismiss()
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
        SecureField("Password", text: $viewModel.oldPassword)
            .padding()
            .focused($selectedField, equals: .oldPassword)
            .neonField(light: selectedField == .oldPassword ? true : false)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
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
        SecureField("New password", text: $viewModel.newPassword)
            .padding()
            .focused($selectedField, equals: .newPassword)
            .neonField(light: selectedField == .newPassword ? true : false)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .newPassword
            }
            .onSubmit {
                selectedField = .newPasswordConfirmation
            }
            .padding(.horizontal)
    }
    
    var newPasswordConfirmationField: some View {
        SecureField("Confirm new password", text: $viewModel.newPasswordConfirmation)
            .padding()
            .focused($selectedField, equals: .newPasswordConfirmation)
            .neonField(light: selectedField == .newPasswordConfirmation ? true : false)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .newPasswordConfirmation
            }
            .onSubmit {
                
            }
            .padding(.horizontal)
    }
    
    var saveButton: some View {
        Button {
            if viewModel.validForm {
                changePassword()
            }
        } label: {
            Text("Save")
                .font(.headline)
        }
    }
}
