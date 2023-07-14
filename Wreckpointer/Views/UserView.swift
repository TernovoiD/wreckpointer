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
        Text("TernovoiD")
            .font(.largeTitle.weight(.bold))
            .padding()
            .neonField(light: true)
            .frame(maxHeight: 80)
    }
    
    var userInfo: some View {
        Text("Oh hi! My name is Danylo Ternovoi, and I'm thrilled to welcome you to my GitHub page. While my professional background lies in the role of a Tanker Fleet Navigational Officer, my true passion lies in the world of iOS app development and all related aspects. On this GitHub page, you'll find a collection of my personal projects and experiments in iOS app development. Through these projects, I aim to demonstrate my growing proficiency in the field and showcase my creativity in crafting delightful user interfaces and seamless functionality.")
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
