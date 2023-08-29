//
//  LoginView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var selectedField: FocusText?
    @EnvironmentObject var state: AppState
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var validForm: Bool {
        if email.isEmpty || password.isEmpty {
            viewModel.showError(withMessage: "Fields cannot be empty.")
            return false
        } else if !email.isValidEmail {
            viewModel.showError(withMessage: "Unvalid username")
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
        case password
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                shipImage
            }
            .ignoresSafeArea()
            .background()
            VStack(spacing: 15) {
                Text("Login")
                    .glassyFont(textColor: .accentColor)
                    .font(.largeTitle)
                    .bold()
                emailField
                passwordField
                signInButton
                createAccountLink
                forgotPasswordLink
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background()
        .onTapGesture {
            selectedField = .none
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            if state.authorizedUser != nil { dismiss() }
            withAnimation(.easeInOut) {
                state.activeUIElement = .none
            }
        }
    }
    
    private func login() async {
        if let user = await viewModel.login(withEmail: email, andPassword: password) {
            selectedField = .none
            state.authorizedUser = user
            dismiss()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
                .environmentObject(LoginViewModel())
                .environmentObject(AppState())
        }
    }
}


// MARK: - Variables

extension LoginView {
    
    var emailField: some View {
        TextField("Email", text: $email)
            .padding()
            .focused($selectedField, equals: .email)
            .neonField(light: selectedField == .email ? true : false)
            .submitLabel(.next)
            .textContentType(.username)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled(true)
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
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .password
            }
            .onSubmit {
                if validForm {
                    Task { await login() }
                }
            }
            .padding(.horizontal)
    }
    
    var signInButton: some View {
        Button {
            if validForm {
                Task { await login() }
            }
        } label: {
            Text("Sign In")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .mask(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
        }
    }
    
    var shipImage: some View {
        Image("ship3")
            .resizable()
            .frame(maxHeight: 300)
            .aspectRatio(0.5, contentMode: .fill)
            .ignoresSafeArea(.keyboard)
    }
    
    var createAccountLink: some View {
        HStack {
            Text("Don't have an account?")
            NavigationLink("Create", destination: RegistrationView())
        }
        .padding(.horizontal, 5)
        .background()
        .mask(RoundedRectangle(cornerRadius: 7))
    }
    
    var forgotPasswordLink: some View {
        NavigationLink("Forgot passsword?", destination: PasswordResetView())
            .padding(.horizontal, 5)
            .background()
            .mask(RoundedRectangle(cornerRadius: 7))
    }
}
