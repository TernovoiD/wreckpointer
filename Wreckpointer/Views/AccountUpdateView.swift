//
//  AccountUpdateView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct AccountUpdateView: View {
    
    @State var bio: String
    @State var image: Data?
    @FocusState var selectedField: FocusText?
    @EnvironmentObject var state: AppState
    @StateObject var viewModel = AccountUpdateViewModel()
    @Environment(\.dismiss) private var dismiss
    
    enum FocusText {
        case info
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $image)
            VStack(spacing: 0) {
                Text("Information:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .padding(.horizontal)
                TextEditor(text: $bio)
                    .frame(height: 200)
                    .focused($selectedField, equals: .info)
                    .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .neonField(light: selectedField == .info ? true : false)
                    .onTapGesture {
                        selectedField = .info
                    }
                    .shadow(radius: 3)
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem { saveButton }
        }
        .navigationTitle("Update")
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .onTapGesture {
            selectedField = .none
        }
    }
    
    var saveButton: some View {
        Button {
            if let user = state.authorizedUser {
                Task {
                    let updatedUser = await viewModel.update(user: user)
                    state.authorizedUser = updatedUser
                }
                dismiss()
            }
        } label: {
            Text("Save")
                .font(.headline)
        }
    }
}

struct AccountUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountUpdateView(bio: "", image: nil)
                .environmentObject(AppState())
                .environmentObject(AccountUpdateViewModel())
        }
    }
}
