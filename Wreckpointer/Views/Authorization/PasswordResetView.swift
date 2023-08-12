//
//  PasswordResetView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import SwiftUI

struct PasswordResetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = PasswordResetViewModel()
    @FocusState var selectedField: FocusText?
    @EnvironmentObject var state: AppState
    
    enum FocusText {
        case email
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
                emailField
                requesPasswordResetButton
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
    
    func resetPassword() {
        Task {
            await viewModel.reset()
            dismiss()
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}


// MARK: - Variables

extension PasswordResetView {
    
    var emailField: some View {
        TextField("Email", text: $viewModel.email)
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
                if viewModel.validForm {
                    resetPassword()
                }
            }
            .padding(.horizontal)
    }
    
    var requesPasswordResetButton: some View {
        Button {
            if viewModel.validForm {
                resetPassword()
            }
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
}
