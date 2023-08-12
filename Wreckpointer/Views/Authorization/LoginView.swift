//
//  LoginView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @FocusState var selectedField: FocusText?
    @EnvironmentObject var state: AppState
    
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
                    .glassyFont(textColor: .indigo)
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
    }
    
    func signIn() {
        Task {
            await viewModel.login()
            let user = await viewModel.fetchUser()
            if let user {
                withAnimation(.easeInOut) {
                    state.authorizedUser = user
                }
            }
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
        TextField("Email", text: $viewModel.email)
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
                selectedField = .password
            }
            .padding(.horizontal)
    }
    
    var passwordField: some View {
        SecureField("Password", text: $viewModel.password)
            .padding()
            .focused($selectedField, equals: .password)
            .neonField(light: selectedField == .password ? true : false)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .password
            }
            .onSubmit {
                if viewModel.validForm {
                    signIn()
                }
            }
            .padding(.horizontal)
    }
    
    var signInButton: some View {
        Button {
            if viewModel.validForm {
                selectedField = .none
                signIn()
            }
        } label: {
            Text("Sign In")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.indigo)
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
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background()
    }
    
    var forgotPasswordLink: some View {
        NavigationLink("Forgot passsword?", destination: PasswordResetView())
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background()
    }
}
