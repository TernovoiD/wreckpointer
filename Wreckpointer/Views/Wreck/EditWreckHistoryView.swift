//
//  EditWreckHistoryView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 19.01.2024.
//

import SwiftUI

struct EditWreckHistoryView: View {
    
    @ObservedObject var viewModel: EditWreckViewModel
    
    var body: some View {
        TextEditor(text: $viewModel.history)
        .padding()
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        EditWreckHistoryView(viewModel: EditWreckViewModel())
    }
}
