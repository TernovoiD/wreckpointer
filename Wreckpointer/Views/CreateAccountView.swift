//
//  CreateAccountView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthenticationViewModel
    @FocusState var selectedField: FocusText?
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""
    @State var error: String = ""
    
    enum FocusText {
        case email
        case username
        case password
        case passwordConfirmation
    }
    
    var isFormValid: Bool {
        if email.isEmpty || username.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
            showFormError(withText: "Fields cannot be empty.")
            return false
        } else if !email.isValidEmail {
            showFormError(withText: "Email is not valid.")
            return false
        } else if !username.isValidName {
            showFormError(withText: "username must contain at least 5 characters.")
            return false
        } else if !password.isValidPassword {
            showFormError(withText: "Password must contain at least 8 characters.")
            return false
        } else if password != passwordConfirmation {
            showFormError(withText: "Passwords do not match! Try again")
            return false
        } else {
            return true
        }
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
                formErrorText
                emailField
                usernameField
                passwordField
                passwordConfirmationField
                createAccountButton
                createAccountLink
            }
            closeButton
        }
        .background()
        .onTapGesture {
            selectedField = .none
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Variables
    
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
                createAccount()
            }
            .padding(.horizontal)
    }
    
    var createAccountButton: some View {
        Button {
            selectedField = .none
            if isFormValid {
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
    
    var formErrorText: some View {
        Text(error)
            .font(.callout)
            .glassyFont(textColor: .red)
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
    
    var closeButton: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                    selectedField = .none
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .padding()
                        .accentColorBorder()
                        .padding()
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    // MARK: - Functions
    
    func clearForm() {
        email = ""
        password = ""
        error = ""
    }
    
    func showFormError(withText text: String) {
        withAnimation(.easeInOut) {
            error = text
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut) {
                error = ""
            }
        }
    }
    
    func createAccount() {
        Task {
            do {
                let newUser = User(username: username, email: email, password: password, confirmPassword: passwordConfirmation)
                try await authVM.createAccount(forUser: newUser)
                clearForm()
                dismiss()
            } catch let error {
                print(error)
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        // Init View model
        let authViewModel = AuthenticationViewModel(userService: userService)
        
        CreateAccountView()
            .environmentObject(authViewModel)
    }
}
