//
//  RegistrationView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import SwiftUI

struct RegistrationView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RegistrationViewModel()
    @FocusState private var selectedField: FocusText?
    @EnvironmentObject private var state: AppState
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    
    var validForm: Bool {
        if email.isEmpty || username.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
            viewModel.showError(withMessage: "Fields cannot be empty.")
            return false
        } else if !email.isValidEmail {
            viewModel.showError(withMessage: "Email is not valid.")
            return false
        } else if !username.isValidName {
            viewModel.showError(withMessage: "username must contain at least 5 characters.")
            return false
        } else if !password.isValidPassword {
            viewModel.showError(withMessage: "Password must contain at least 8 characters.")
            return false
        } else if password != passwordConfirmation {
            viewModel.showError(withMessage: "Passwords do not match! Try again")
            return false
        } else {
            return true
        }
    }
    
    enum FocusText {
        case email
        case username
        case password
        case passwordConfirmation
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                shipImage
            }
            .ignoresSafeArea()
            VStack(spacing: 15) {
                Text("New account")
                    .glassyFont(textColor: .indigo)
                    .font(.largeTitle)
                    .bold()
                emailField
                usernameField
                passwordField
                passwordConfirmationField
                createAccountButton
                createAccountLink
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .background()
        .onTapGesture {
            selectedField = .none
        }
    }
    
    private func clearForm() {
        username = ""
        email = ""
        password = ""
        passwordConfirmation = ""
    }
    
    private func createAccount() {
        let user = User(username: username,
                        email: email,
                        password: password,
                        confirmPassword: passwordConfirmation)
        Task {
            if let createdUser = await viewModel.register(user: user) {
                clearForm()
                state.authorizedUser = createdUser
            }
        }
    }
    
    private func authorize(user: User) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                state.authorizedUser = user
                dismiss()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(RegistrationViewModel())
            .environmentObject(AppState())
    }
}


// MARK: - Variables

extension RegistrationView {
    
    var emailField: some View {
        TextField("Email", text: $email)
            .padding()
            .focused($selectedField, equals: .email)
            .neonField(light: selectedField == .email ? true : false)
            .submitLabel(.next)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .email
            }
            .onSubmit {
                selectedField = .username
            }
            .padding(.horizontal)
    }
    
    var usernameField: some View {
        TextField("Username", text: $username)
            .padding()
            .focused($selectedField, equals: .username)
            .neonField(light: selectedField == .username ? true : false)
            .submitLabel(.next)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .username
            }
            .onSubmit {
                selectedField = .password
            }
            .padding(.horizontal)
    }
    
    var passwordField: some View {
        SecureField("Password", text: $password)
            .padding()
            .focused($selectedField, equals: .password)
            .neonField(light: selectedField == .password ? true : false)
            .submitLabel(.next)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .password
            }
            .onSubmit {
                selectedField = .passwordConfirmation
            }
            .padding(.horizontal)
    }
    
    var passwordConfirmationField: some View {
        SecureField("Password", text: $passwordConfirmation)
            .padding()
            .focused($selectedField, equals: .passwordConfirmation)
            .neonField(light: selectedField == .passwordConfirmation ? true : false)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .passwordConfirmation
            }
            .onSubmit {
                if validForm {
                    createAccount()
                }
            }
            .padding(.horizontal)
    }
    
    var createAccountButton: some View {
        Button {
            if validForm {
                selectedField = .none
                createAccount()
            }
        } label: {
            Text("Create")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.indigo)
                .foregroundColor(.white)
                .mask(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
        }
    }
    
    var shipImage: some View {
        Image("ship1")
            .resizable()
            .frame(maxHeight: 300)
            .aspectRatio(0.5, contentMode: .fill)
            .ignoresSafeArea(.keyboard)
    }
    
    var createAccountLink: some View {
        HStack {
            Text("Already have an account?")
            Button {
                dismiss()
            } label: {
                Text("Sign In")
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background()
        .mask(RoundedRectangle(cornerRadius: 25))
    }
}
