//
//  ContentView.swift
//  UploadToApi
//
//  Created by PHONG on 02/08/2021.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @StateObject var auth = AuthViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("rememberMe") var rememberMe = false
    var body: some View {
        ZStack{
            if self.auth.isLogin {
                ListChatView()
                    .environmentObject(auth)
                    .transition(.move(edge: .trailing))
                   
            }else{
                LoginView().environmentObject(auth)
                    .transition(.move(edge: .leading))
            }
        }.onAppear{
            auth.onAppear()
        }
        .alert(isPresented: $auth.showAlert) {
            Alert(title: Text("Hey"), message: Text("Do you want save account"), primaryButton: .default(Text("Save"), action: {
                rememberMe = true

            }), secondaryButton: .destructive(Text("Cancel")))
        }
         
    }
}

struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
