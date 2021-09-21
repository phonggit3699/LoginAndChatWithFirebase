//
//  SignInView.swift
//  UploadToApi
//
//  Created by PHONG on 02/08/2021.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var repassword: String = ""
    @State private var showPassword = false
    @State private var showRePassword = false
    @State private var isCreateAccount = false
    @State private var isTabFieldUsername = false
    @State private var isTabFieldPassword = false
    @State private var isTabFieldRePassword = false
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        ZStack{
            VStack {
                //username field
                TextField("Email", text: $username)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" || self.isTabFieldUsername ? Color.black: Color.gray, lineWidth: 1))
                    .padding(.horizontal)
                    .onTapGesture {
                        self.isTabFieldUsername.toggle()
                        self.isTabFieldPassword = false
                        self.isTabFieldRePassword = false
                    }.padding(.top, 10)
                
                // Password field
                ZStack{
                    if self.showPassword {
                        TextField("Password", text: $password)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" || self.isTabFieldPassword ? Color.black: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                self.isTabFieldPassword.toggle()
                                self.isTabFieldUsername = false
                                self.isTabFieldRePassword = false
                            }
                    }else{
                        SecureField("Password", text: $password)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.password !=  "" || self.isTabFieldPassword ? Color.black: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                self.isTabFieldPassword.toggle()
                                self.isTabFieldUsername = false
                                self.isTabFieldRePassword = false
                            }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.password != "" || self.isTabFieldPassword ? Color.black: Color.gray)
                        }).padding(.trailing, 5)
                    }
                }.padding([.horizontal,.top])
                
                // Confirm Password field
                ZStack{
                    if self.showRePassword {
                        TextField("Confirm password", text: $repassword)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword != "" || self.isTabFieldRePassword ? Color.black: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                self.isTabFieldRePassword.toggle()
                                self.isTabFieldUsername = false
                                self.isTabFieldPassword = false
                            }
                    }else{
                        SecureField("Confirm password", text: $repassword)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword !=  "" || self.isTabFieldRePassword ? Color.black: Color.gray, lineWidth: 1))
                            .onTapGesture {
                                self.isTabFieldRePassword.toggle()
                                self.isTabFieldUsername = false
                                self.isTabFieldPassword = false
                            }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showRePassword.toggle()
                        }, label: {
                            Image(systemName: self.showRePassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.repassword != "" || self.isTabFieldRePassword ? Color.black: Color.gray)
                            
                        }).padding(.trailing, 5)
                    }
                }.padding([.horizontal,.top])
                
                Button(action: {
                    self.auth.checkField(email: self.username, password: self.password, repass: self.repassword)
                    
                    self.auth.createAccount(email: username, password: password)
                }, label: {
                    Text("Create acccount")
                        .foregroundColor(self.password != "" && self.username != "" ? Color.black: Color.gray)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("lightBlue")))
                }).disabled(self.password == "" || self.username == "" || self.repassword == "")
                .padding(.vertical, 10)
                
            }.padding()
            .background(Color.white.opacity(0.2).clipShape(RoundedRectangle.init(cornerRadius: 15)))
        }.navigationTitle("Sign In")
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color("lightBlue"), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
        .alert(isPresented: self.$auth.showAlert, content: {
            Alert(title: Text("Erorr"), message: Text("\(self.auth.error)"), dismissButton: .default(Text("OK")))
        })
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(AuthViewModel())
    }
}
