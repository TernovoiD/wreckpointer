//
//  ForgotPasswordView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthenticationViewModel
    @FocusState var selectedField: FocusText?
    @State var email: String = ""
    @State var error: String = ""
    
    enum FocusText {
        case email
    }
    
    var isFormValid: Bool {
        if email.isEmpty {
            showFormError(withText: "Email field is empty!")
            return false
        } else if !email.isValidEmail {
            showFormError(withText: "Email is not valid.")
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
                Text("Reset password")
                    .glassyFont(textColor: .indigo)
                    .font(.largeTitle)
                    .bold()
                Text("Instructions will be send on your email.")
                formErrorText
                emailField
                requesPasswordResetButton
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
            .submitLabel(.go)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .onTapGesture {
                selectedField = .email
            }
            .onSubmit {
                requestPasswordReset()
            }
            .padding(.horizontal)
    }
    
    var requesPasswordResetButton: some View {
        Button {
            requestPasswordReset()
        } label: {
            Text("Send request")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.indigo)
                .foregroundColor(.white)
                .mask(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
        }
    }
    
    var shipImage: some View {
        Image("ship2")
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
            Text("Remember your account?")
            Button {
                dismiss()
            } label: {
                Text("Sign In")
            }
            
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background()
        .mask(RoundedRectangle(cornerRadius: 15))
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
    
    func requestPasswordReset() {
        if isFormValid {
            selectedField = .none
            clearForm()
            print("Password Reset")
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        // Init View model
        let authViewModel = AuthenticationViewModel(userService: userService)
        
        ForgotPasswordView()
            .environmentObject(authViewModel)
    }
}
