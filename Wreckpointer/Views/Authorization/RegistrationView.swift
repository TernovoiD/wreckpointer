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
    
    var validForm: Bool {
        if email.isEmpty || username.isEmpty || password.isEmpty {
            viewModel.showError(withMessage: "Fields cannot be empty.")
            return false
        }else if !email.isValidEmail {
            viewModel.showError(withMessage: "Email is not valid.")
            return false
        } else if !username.isValidUsername {
            viewModel.showError(withMessage: "Username must be 3 to 13 characters. Only chars, numbers and underscore allowed")
            return false
        } else if !password.isValidPassword {
            viewModel.showError(withMessage: "Password must contain at least 6 characters.")
            return false
        } else {
            return true
        }
    }
    
    enum FocusText {
        case email
        case username
        case password
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
                    .glassyFont(textColor: .accentColor)
                    .font(.largeTitle)
                    .bold()
                usernameField
                emailField
                passwordField
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
    
    private func createAccount() {
        let user = User(username: username,
                        email: email,
                        password: password,
                        confirmPassword: password)
        Task {
            if let createdUser = await viewModel.register(user: user) {
                authorize(user: createdUser)
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
                selectedField = .email
            }
            .padding(.horizontal)
    }
    
    var emailField: some View {
        TextField("Email", text: $email)
            .padding()
            .focused($selectedField, equals: .email)
            .neonField(light: selectedField == .email ? true : false)
            .submitLabel(.next)
            .autocorrectionDisabled(true)
            .textContentType(.username)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .email
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
            .textContentType(.newPassword)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .password
            }
            .onSubmit {
                selectedField = .none
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
                .background(Color.accentColor)
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
        .padding(.horizontal, 5)
        .background()
        .mask(RoundedRectangle(cornerRadius: 7))
    }
}
