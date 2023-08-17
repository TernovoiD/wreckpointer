//
//  AccountView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var state: AppState
    
    var body: some View {
        ZStack {
            UserAccountView()
                .navigationTitle("")
            LoginView()
                .offset(y: state.authorizedUser == nil ? 0 : 1000)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountView()
                .environmentObject(AppState())
        }
    }
}
