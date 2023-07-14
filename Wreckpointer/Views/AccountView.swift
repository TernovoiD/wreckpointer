//
//  AccountView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            UserView()
            LoginView()
                .offset(y: authVM.user == nil ? 0 : 1000)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        // Init View model
        let authViewModel = AuthenticationViewModel(userService: userService)
        
        AccountView()
            .environmentObject(authViewModel)
    }
}
