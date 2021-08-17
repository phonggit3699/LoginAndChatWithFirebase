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
         
    }
}

struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
