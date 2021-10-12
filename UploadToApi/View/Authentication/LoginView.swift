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
    @Environment(\.colorScheme) var colorScheme
    
   
    
    var body: some View {
        NavigationView{
            ZStack{
                if auth.showProgress {
                    ProgressView()
                }
                else{
                    
                    VStack{
                        // Logo
                        Image("Circle-icons")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .offset(y: -50)
                        
                        
                        VStack {
                            //username field
                            TextField("Email", text: $username)
                                .foregroundColor(textColor)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" || self.isTabFieldUsername ? textColor: Color.gray, lineWidth: 1))
                                .padding(.horizontal)
                                .onTapGesture {
                                    self.isTabFieldUsername.toggle()
                                    self.isTabFieldPassword = false
                                }.padding(.top, 10)
                            
                            // Password field
                            ZStack{
                                if self.showPassword {
                                    TextField("Password", text: $password)
                                        .foregroundColor(textColor)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" || self.isTabFieldPassword ? textColor: Color.gray, lineWidth: 1))
                                        .onTapGesture {
                                            self.isTabFieldPassword.toggle()
                                            self.isTabFieldUsername = false
                                        }
                                }else{
                                    SecureField("Password", text: $password)
                                        .foregroundColor(textColor)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password !=  "" || self.isTabFieldPassword ? textColor: Color.gray, lineWidth: 1))
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
                                            .foregroundColor(self.password != "" || self.isTabFieldPassword ? textColor: Color.gray)
                                    }).padding(.trailing, 5)
                                }
                            }.padding(.horizontal)
                            .padding(.top, 10)
                            
                            HStack{
                                //TODO: Button Create account
                                Button(action: {
                                    self.isCreateAccount.toggle()
                                }, label: {
                                    Text("Create new account")
                                        .font(.subheadline)
                                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                                })
                                
                                Spacer()
                                //TODO: Button forgot pass
                                Button(action: {
                                    self.isResetPassword.toggle()
                                }, label: {
                                    Text("Forgot password ?")
                                        .font(.subheadline)
                                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                                })
                            }.padding(.horizontal)
                            .padding(.top, 10)
                            
                            
                            //TODO: Button login by account
                            Button(action: {
                                auth.showProgress = true
                                auth.login(email: self.username, password: self.password)
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Login")
                                        .foregroundColor(self.password != "" && self.username != "" ? Color.white: Color.gray)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 150, height: 50)
                                        .background(Capsule().fill(Color("mainBg")))
                                    Spacer()
                                }
                            }).disabled(self.password == "" || self.username == "")
                            .padding(.top, 10)
                            
                            //TODO: Button Remember user
                            Button(action: {
                                withAnimation {
                                    isRemember.toggle()
                                }
                            }, label: {
                                HStack{
                                    Image(systemName: isRemember ? "checkmark.square" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                                    
                                    Text("Remember Me")
                                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                                }
                                
                            })
                            .padding(.top, 10)
                            .onChange(of: isRemember) { value in
                                if value {
                                    rememberMe = true
                                }else{
                                    rememberMe = false
                                }
                            }
                            
                            // TODO: Login with GG btn
                            Button(action: {
                                auth.showProgress = true
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
                            })
                            .padding(.vertical, 10)
                            .frame(height: 60)
                            
                            // TODO: Login with FB btn
                            Button(action: {
                                auth.showProgress = true
                                auth.signInWithFaceBook()
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
                                
                            }).padding(.vertical, 10)
                            .frame(height: 60)
                            
                            //Link to SignIn View
                            NavigationLink(
                                destination: SignInView(),
                                isActive: self.$isCreateAccount,
                                label: {
                                    EmptyView()
                                })
                            
                            //Link to Reset Password View
                            NavigationLink(
                                destination: ResetPasswordView().environmentObject(auth),
                                isActive: self.$isResetPassword,
                                label: {
                                    EmptyView()
                                })
                            
                        }
                        .padding()
                        .background(Color.white.opacity(0.2).clipShape(RoundedRectangle.init(cornerRadius: 15)))
                        .offset(y: -40)
                    }
                }
                
            }
            .navigationBarHidden(true)
            .padding()
            .padding(.top, 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color("mainBg")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .alert(isPresented: self.$auth.showError, content: {
                Alert(title: Text("Erorr"), message: Text("\(self.auth.error)"), dismissButton: .default(Text("OK")))
            })
            .onAppear{
                auth.onAppear()
                UITextField.appearance().tintColor = UIColor(textColor)
            }
            .ignoresSafeArea()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}
