//
//  UserView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                accountImage
                    .padding(.top, 100)
                username
                Divider()
                    .padding(.top)
                userInfo
                Divider()
                Spacer()
            }
            VStack {
                HStack(alignment: .top) {
                    CloseButton()
                    Spacer()
                    AccountMenu()
                }
                Spacer()
            }
        }
        .background(.ultraThinMaterial)
    }
    
    var accountImage: some View {
        Image(systemName: "person.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 300)
            .clipShape(Circle())
            .background(Circle().stroke(lineWidth: 3).foregroundColor(.purple))
    }
    
    var username: some View {
        Text(authVM.user?.username ?? "unknown")
            .font(.largeTitle.weight(.bold))
            .padding()
            .neonField(light: true)
            .frame(maxHeight: 80)
    }
    
    var userInfo: some View {
        Text(authVM.user?.username ?? "No info")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        // Init View model
        let authViewModel = AuthenticationViewModel(userService: userService)
        
        ZStack {
            Color.cyan
                .ignoresSafeArea()
            UserView()
                .environmentObject(authViewModel)
        }
    }
}
