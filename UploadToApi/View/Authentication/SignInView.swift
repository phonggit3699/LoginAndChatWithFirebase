//
//  SignInView.swift
//  UploadToApi
//
//  Created by PHONG on 02/08/2021.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repassword: String = ""
    @State private var showPassword = false
    @State private var showRePassword = false
    @State private var isCreateAccount = false
    @State private var isTabFieldUsername = false
    @State private var isTabFieldEmail = false
    @State private var isTabFieldPassword = false
    @State private var isTabFieldRePassword = false
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        ZStack{
            VStack {
                //username field
                TextField("Username", text: $username)
                    .padding(.vertical, 10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" || self.isTabFieldUsername ? textColor: Color.gray, lineWidth: 1))
                    .padding(.horizontal)
                    .onTapGesture {
                        resetBoder()
                        self.isTabFieldUsername.toggle()
                    }.padding(.top, 10)
                
                //username field
                TextField("Email", text: $email)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" || self.isTabFieldEmail ? textColor: Color.gray, lineWidth: 1))
                    .padding(.horizontal)
                    .onTapGesture {
                        resetBoder()
                        self.isTabFieldEmail.toggle()
                    }.padding(.top, 10)
                
                // Password field
                ZStack{
                    if self.showPassword {
                        TextField("Password", text: $password)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" || self.isTabFieldPassword ? textColor: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                resetBoder()
                                self.isTabFieldPassword.toggle()
                            }
                    }else{
                        SecureField("Password", text: $password)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.password !=  "" || self.isTabFieldPassword ? textColor: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                resetBoder()
                                self.isTabFieldPassword.toggle()
                            }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.password != "" || self.isTabFieldPassword ? textColor: Color.gray)
                        }).padding(.trailing, 5)
                    }
                }.padding([.horizontal,.top])
                
                // Confirm Password field
                ZStack{
                    if self.showRePassword {
                        TextField("Confirm password", text: $repassword)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword != "" || self.isTabFieldRePassword ? textColor: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                resetBoder()
                                self.isTabFieldRePassword.toggle()
                            }
                    }else{
                        SecureField("Confirm password", text: $repassword)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword !=  "" || self.isTabFieldRePassword ? textColor: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                resetBoder()
                                self.isTabFieldRePassword.toggle()
                            }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showRePassword.toggle()
                        }, label: {
                            Image(systemName: self.showRePassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.repassword != "" || self.isTabFieldRePassword ? textColor: Color.gray)
                            
                        }).padding(.trailing, 5)
                    }
                }.padding([.horizontal,.top])
                
                Button(action: {
                    self.auth.createAccount(email: email, password: password)
                }, label: {
                    Text("Create acccount")
                        .foregroundColor(self.password != "" && self.username != "" ? Color.black: Color.gray)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("mainBg")))
                }).disabled(self.password == "" || self.username == "" || self.repassword == "")
                .padding(.vertical, 10)
                
            }.padding()
            .background(Color.white.opacity(0.2).clipShape(RoundedRectangle.init(cornerRadius: 15)))
        }
        .navigationBarHidden(false)
        .navigationTitle("Sign In")
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color("mainBg")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
        .alert(isPresented: self.$auth.showError, content: {
            Alert(title: Text("Erorr"), message: Text("\(self.auth.error)"), dismissButton: .default(Text("OK")))
        })
        .alert(isPresented: self.$auth.showAlert, content: {
            Alert(title: Text("Notification"), message: Text("\(self.auth.alert)"), dismissButton: .default(Text("OK")))
        })
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(AuthViewModel())
    }
}

extension SignInView {
    func resetBoder() {
        self.isTabFieldUsername = false
        self.isTabFieldPassword = false
        self.isTabFieldEmail = false
        self.isTabFieldRePassword = false
    }
}
