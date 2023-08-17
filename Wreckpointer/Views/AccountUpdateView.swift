//
//  AccountUpdateView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct AccountUpdateView: View {
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var selectedField: FocusText?
    @StateObject private var viewModel = AccountUpdateViewModel()
    @Binding var user: User?
    @State var bio: String = ""
    @State var image: Data?
    
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
    
    private func update() async {
        if var userToUpdate = user {
            userToUpdate.image = image
            userToUpdate.bio = bio
            
            let updatedUser = await viewModel.update(user: userToUpdate)
            if let updatedUser {
                user = updatedUser
                dismiss()
            }
        }
    }
    
    var saveButton: some View {
        Button {
            Task { await update() }
        } label: {
            Text("Save")
                .font(.headline)
        }
    }
}

struct AccountUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountUpdateView(user: .constant(User()))
                .environmentObject(AppState())
                .environmentObject(AccountUpdateViewModel())
        }
    }
}
