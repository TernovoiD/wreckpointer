//
//  LoginPageView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import SwiftUI

struct LoginPageView: View {
    
    @ObservedObject var viewModel: ModeratorViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var selectedField: FocusText?
    
    @State private var email: String = ""
    @State private var password: String = ""
    
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
            .background()
            VStack(spacing: 15) {
                VStack(alignment: .trailing) {
                    Text("Wreckpointer")
                        .font(.largeTitle.weight(.black))
                    Text(".moderator")
                        .foregroundStyle(Color.accentColor)
                }
                .font(.title2.bold())
                    
                emailField
                passwordField
                signInButton
            }
        }
        .background()
        .onTapGesture {
            selectedField = .none
        }
    }
    
    private func login() {
        if !email.isEmpty && !password.isEmpty {
            Task {
                await viewModel.login(email: email,password: password)
            }
        }
    }
}


// MARK: - Variables

extension LoginPageView {
    
    var emailField: some View {
        TextField("Email", text: $email)
            .padding()
            .focused($selectedField, equals: .email)
            .coloredBorder(color: selectedField == .email ? Color.accentColor : Color.clear)
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
            .coloredBorder(color: selectedField == .password ? Color.accentColor : Color.clear)
            .submitLabel(.go)
            .autocorrectionDisabled(true)
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .password
            }
            .onSubmit {
                login()
            }
            .padding(.horizontal)
    }
    
    var signInButton: some View {
        Button {
            if true {
                login()
            }
        } label: {
            Text("Sign In")
                .frame(maxWidth: .infinity)
                .padding()
                .coloredBorder(color: .primary)
                .foregroundStyle(Color.primary)
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
}

#Preview {
    LoginPageView(viewModel: ModeratorViewModel())
}
