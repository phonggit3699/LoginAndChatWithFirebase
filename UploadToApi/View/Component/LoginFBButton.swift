//
//  LoginFBButton.swift
//  UploadToApi
//
//  Created by PHONG on 04/08/2021.
//

import SwiftUI
import FBSDKLoginKit
import FBSDKCoreKit

struct LoginFBButton: UIViewRepresentable {
    @EnvironmentObject var auth: AuthViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    func makeUIView(context: Context) -> FBLoginButton {
        let fbButton = FBLoginButton()
        fbButton.delegate = context.coordinator
        

        fbButton.permissions = ["public_profile", "email"]
        return fbButton
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        
    }
    
    class Coordinator:NSObject, LoginButtonDelegate{
        let parent: LoginFBButton
        
        init(_ parent: LoginFBButton){
            self.parent = parent
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let token = AccessToken.current,
               !token.isExpired {
     
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("Logout")
        }
        
        
    }
}
