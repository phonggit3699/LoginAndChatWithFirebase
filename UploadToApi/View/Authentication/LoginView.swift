//
//  LoginView.swift
//  UploadToApi
//
//  Created by PHONG on 02/08/2021.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var isCreateAccount = false
    @State private var isResetPassword = false
    @State private var isTabFieldUsername = false
    @State private var isTabFieldPassword = false
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("rememberMe") var rememberMe = false
    @State private var isRemember = false
    
    var body: some View {
        NavigationView{
            ZStack{
                if auth.showProgress {
                    ProgressView()
                }
                else{
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
                                    }
                            }else{
                                SecureField("Password", text: $password)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password !=  "" || self.isTabFieldPassword ? Color.black: Color.gray, lineWidth: 1))
                                    .onTapGesture {
                                        self.isTabFieldPassword.toggle()
                                        self.isTabFieldUsername = false
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
                        
                        Button(action: {
                            self.isCreateAccount.toggle()
                        }, label: {
                            Text("Create new acccount")
                        }).padding(.vertical, 10)
                        
                        //TODO: Remember user
                        HStack{
                            
                            Button(action: {
                                withAnimation {
                                    isRemember.toggle()
                                }
                            }, label: {
                                Image(systemName: isRemember ? "checkmark.square" : "square")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                            })
                            Text("Remember Me")
                        }.padding(.bottom, 10)
                        .onChange(of: isRemember) { value in
                            if value {
                                rememberMe = true
                            }else{
                                rememberMe = false
                            }
                        }
                        
                        NavigationLink(
                            destination: SignInView(),
                            isActive: self.$isCreateAccount,
                            label: {
                                EmptyView()
                            })
                        
                        //TODO: Login by account
                        Button(action: {
                            self.auth.login(email: self.username, password: self.password)
                            self.password = ""
                            self.username = ""
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Login")
                                    .foregroundColor(self.password != "" && self.username != "" ? Color.black: Color.gray)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(width: 150, height: 50)
                                    .background(Capsule().fill(Color("lightBlue")))
                                Spacer()
                            }
                        }).disabled(self.password == "" || self.username == "")
                        .padding(.vertical, 10)
                        // TODO: Login with GG btn
                        Button(action: {
                            auth.sighInWithGoogle()
                        }, label: {
                            ZStack {
                                HStack(alignment: .center) {
                                    Image("google")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .padding(.leading, 5)
                                    Spacer()
                                    
                                }
                                Text("Continue with Google")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .padding()
                            }.background(Color.white.cornerRadius(3))
                            
                            
                        }).padding()
                        .frame(height: 60)
                        
                        // TODO: Login with FB btn
                        Button(action: {
                            self.auth.signInWithFaceBook()
                        }, label: {
                            ZStack {
                                HStack(alignment: .center) {
                                    Image("facebook")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .padding(.leading, 5)
                                    Spacer()
                                    
                                }
                                Text("Continue with Facebook")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding()
                            }.background(Color.blue.cornerRadius(3))
                            
                            
                        }).padding()
                        .frame(height: 60)
                        
                        NavigationLink(
                            destination: ResetPasswordView().environmentObject(auth),
                            isActive: self.$isResetPassword,
                            label: {
                                EmptyView()
                            })
                        
                        Button(action: {
                            self.isResetPassword.toggle()
                        }, label: {
                            Text("Forgot password")
                        }).padding(.top)
                        
                    }
                    .padding()
                    .background(Color.white.opacity(0.2).clipShape(RoundedRectangle.init(cornerRadius: 15)))
                }
                
            }.navigationTitle("Login")
            .padding()
            .padding(.top, 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color("lightBlue"), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .alert(isPresented: self.$auth.showAlert, content: {
                Alert(title: Text("Erorr"), message: Text("\(self.auth.erorr)"), dismissButton: .default(Text("OK")))
            })
            .ignoresSafeArea()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}
