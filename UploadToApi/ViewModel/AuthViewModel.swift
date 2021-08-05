//
//  AuthViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 03/08/2021.
//

import Foundation
import Firebase
import SwiftUI
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit


class AuthViewModel: ObservableObject {
    @Published var isLogin = false
    @Published var showAlert = false
    @Published var erorr: String = ""
    
    let auth = Auth.auth()
    
    func createAccount(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            withAnimation(){
                self.isLogin = true
            }
            
        }
    }
    
    func login(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { re, error in
            if let error = error {
                self.erorr = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            
            withAnimation(){
                self.isLogin = true
            }
        }
    }
    
    func checkField(username: String, password: String, repass: String){
        if (password.count < 6){
            showAlert.toggle()
            self.erorr = "Password must greater 6 character"
        }
        
        if username != "" && password != repass{
            showAlert.toggle()
            self.erorr = "Password missmath"
        }
    }
    
    func logout(){
        do {
            try auth.signOut()
            withAnimation(){
                isLogin = false
            }
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func sighInWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        guard let presenting = UIApplication.shared.windows.first?.rootViewController else{
            return
        }
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presenting) { [unowned self] user, error in
            
            if let error = error {
                self.erorr = error.localizedDescription
                showAlert.toggle()
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                withAnimation(){
                    self.isLogin = true
                }
                
            }
            
        }
    }
    
    func signInWithFaceBook(token: String) {
        let credential = FacebookAuthProvider
            .credential(withAccessToken: token)
        auth.signIn(with: credential) { authResult, error in
            if let error = error {
                self.erorr = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            
            withAnimation(){
                self.isLogin = true
            }
            
        }
    }
    
    func resetPassword(username: String) {
        auth.sendPasswordReset(withEmail: username) { error in
            if let error = error {
                self.erorr = error.localizedDescription
                self.showAlert.toggle()
            }else{
                self.erorr = "We send link reset to email \(username)"
                self.showAlert.toggle()
                
            }
            
        }
    }
}
