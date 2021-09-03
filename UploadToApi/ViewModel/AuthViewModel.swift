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
    @Published var showProgress = false
    @Published var erorr: String = ""
    @Published var fbLoginManager = LoginManager()
    @AppStorage("currentUser") var user = ""
    @AppStorage("userID") var userID = ""
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    
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
        if erorr.isEmpty{
            self.showProgress = true
        }
        auth.signIn(withEmail: email, password: password) { re, error in
            if let error = error {
                self.erorr = error.localizedDescription
                self.showAlert.toggle()
                self.showProgress = false
                return
            }
            
            
            guard let user = self.auth.currentUser else{
                return
            }
            self.user = user.displayName  ?? user.email!
            self.userID = user.uid
            self.userPhotoURL = user.photoURL
            
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
            self.showProgress = false
            withAnimation(){
                isLogin = false
            }
            self.user = ""
            self.userID = ""
            self.userPhotoURL = nil
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func sighInWithGoogle(){
        if erorr.isEmpty{
            self.showProgress = true
        }
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
                self.showProgress = false
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
                    self.showProgress = false
                    return
                }

                guard let user = auth.currentUser else{
                    return
                }
                self.user = user.displayName  ?? user.email!
                self.userID = user.uid
                self.userPhotoURL = user.photoURL
                withAnimation(){
                    self.isLogin = true
                    
                }
            }
            
        }
    }
    func signInWithFaceBook() {
        if erorr.isEmpty{
            self.showProgress = true
        }
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: nil) { res, error in
            if let error = error {
                self.erorr = error.localizedDescription
                self.showProgress = false
                self.showAlert.toggle()
                return
            }
            if let token = AccessToken.current,
               !token.isExpired {
                self.auth.signIn(with: FacebookAuthProvider
                                    .credential(withAccessToken: token.tokenString)) { authResult, error in
                    if let error = error {
                        self.erorr = error.localizedDescription
                        self.showAlert.toggle()
                        self.showProgress = false
                        return
                    }
                    
                    guard let user = self.auth.currentUser else{
                        return
                    }
                    self.user = user.displayName  ?? user.email!
                    self.userID = user.uid
                    self.userPhotoURL = user.photoURL
                    withAnimation(){
                        self.isLogin = true
                    }
                }
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
    
    func onAppear(){
        if self.user != "" && self.userID != "" {
            self.isLogin = true
        }
    }
}
