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
    @Published var showError = false
    @Published var showProgress = false
    @Published var error: String = ""
    @Published var fbLoginManager = LoginManager()
    
    @AppStorage("currentUser") var user = ""
    @AppStorage("userID") var userID = ""
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    @AppStorage("rememberMe") var rememberMe = false
    
    static let shared = AuthViewModel()
    
    let auth = Auth.auth()
    
    //TODO: Call when app terminated to logout in UIApplicationDelegate
    var isRemember: Bool {
        if rememberMe {
            return true
        }
        else{
            return false
        }
    }
    
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
        //Validate text input
        checkField(email: email, password: password, repass: password)
        
        auth.signIn(withEmail: email, password: password) { re, error in
            if let error = error {
                print(error.localizedDescription)
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
                self.error = ""
            }
        }
    }
    
    func checkField(email: String, password: String, repass: String){
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        
        //        let phoneRegEx = "^(0?)(3[2-9]|5[6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])[0-9]{7}$" //Phone of vietnam
        
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if email.isEmpty {
            showError.toggle()
            self.error = "Email is invalid"
            return
        }
        
        if !emailPred.evaluate(with: email) {
            showError.toggle()
            self.error = "The email address is badly formatted"
            return
        }
        
        if (password.count < 6){
            showError.toggle()
            self.error = "Password must greater 6 character"
            return
        }
        
        if email != "" && password != repass{
            showError.toggle()
            self.error = "Password missmath"
            return
        }
    }
    
    func logout(){
        do {
            print("run")
            try auth.signOut()
            DispatchQueue.main.async {
                withAnimation(){
                    self.isLogin = false
                }
            }
            self.showProgress = false
            self.user = ""
            self.userID = ""
            self.userPhotoURL = nil
            self.rememberMe = false
            self.error = ""
        } catch{
            self.error = error.localizedDescription
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
                self.error = error.localizedDescription
                self.showProgress = false
                showError.toggle()
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
                DispatchQueue.main.async {
                    withAnimation(){
                        self.isLogin = true
                        showAlert.toggle()
                        self.error = ""
                    }

                }
                
            }
            
        }
    }
    func signInWithFaceBook() {
        
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: nil) { res, error in
            if let error = error {
                self.error = error.localizedDescription
                self.showProgress = false
                self.showError.toggle()
                return
            }
            if let token = AccessToken.current,
               !token.isExpired {
                self.auth.signIn(with: FacebookAuthProvider
                                    .credential(withAccessToken: token.tokenString)) { authResult, error in
                    if let error = error {
                        self.error = error.localizedDescription
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
                        self.showAlert.toggle()
                        self.error = ""
                    }
                }
            }
        }
    }
    
    func resetPassword(username: String) {
        auth.sendPasswordReset(withEmail: username) { error in
            if let error = error {
                self.error = error.localizedDescription
                self.showError.toggle()
            }else{
                self.error = "We send link reset to email \(username)"
                self.showError.toggle()
                
            }
            
        }
    }
    
    //check authentication
    func onAppear(){
        if self.user != "" && self.userID != "" {
            self.isLogin = true
        }
    }
}
