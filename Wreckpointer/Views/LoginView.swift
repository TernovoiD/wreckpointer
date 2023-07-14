//
//  LoginView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    @FocusState var selectedField: FocusText?
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    enum FocusText {
        case email
        case password
    }
    
    var isFormValid: Bool {
        if email.isEmpty || password.isEmpty {
            showFormError(withText: "Fields cannot be empty.")
            return false
        } else if !email.isValidEmail {
            showFormError(withText: "Email is not valid.")
            return false
        } else if !password.isValidPassword {
            showFormError(withText: "Password must contain at least 6 characters.")
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    shipImage
                }
                .ignoresSafeArea()
                VStack(spacing: 15) {
                    Text("Login")
                        .glassyFont(textColor: .indigo)
                        .font(.largeTitle)
                        .bold()
                    formErrorText
                    emailField
                    passwordField
                    signInButton
                    createAccountLink
                    forgotPasswordLink
                }
                closeButton
            }
            .background()
            .onTapGesture {
                selectedField = .none
            }
        }
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
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .password
            }
            .onSubmit {
                signIn()
            }
            .padding(.horizontal)
    }
    
    var signInButton: some View {
        Button {
                selectedField = .none
                if isFormValid {
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
    
    var formErrorText: some View {
        Text(error)
            .font(.callout)
            .glassyFont(textColor: .red)
    }
    
    var createAccountLink: some View {
        HStack {
            Text("Don't have an account?")
            NavigationLink("Create", destination: CreateAccountView())
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background()
    }
    
    var forgotPasswordLink: some View {
        NavigationLink("Forgot passsword?", destination: ForgotPasswordView())
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background()
    }
    
    var closeButton: some View {
        VStack {
            HStack {
                CloseButton()
                    .onTapGesture {
                        selectedField = .none
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
    
    func signIn() {
        Task {
            do {
                try await authVM.logIn(email: email, password: password)
                clearForm()
            } catch let error {
                print(error)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        // Init View model
        let authViewModel = AuthenticationViewModel(userService: userService)
        
        LoginView()
            .environmentObject(authViewModel)
    }
}
