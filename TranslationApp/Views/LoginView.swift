//
//  LoginView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @ObservedObject var loginViewHandler = LoginViewHandler()
    enum LoginField: Hashable {
        case email
        case password
    }
    @FocusState private var fieldInFocus: LoginField?
    
    
    var body: some View {
        ZStack{
            Color("appColor")
                .ignoresSafeArea()
            
            VStack{
                Text("Login")
                    .padding()
                    .bold()
                    .font(.system(size:32))
                    .foregroundColor(Color("textColor"))
                    .padding()
                    .cornerRadius(18)
                
                TextField(text: $loginViewHandler.email){
                    Text("Email").foregroundColor(.gray)
                }
                    .font(.system(size:18))
                    .frame(width: 300, height: 20, alignment: .center)
                    .foregroundColor(Color.black)
                    .padding()
                    .background {
                        Color("inputColor")
                    }
                    .cornerRadius(18)
                    .cornerRadius(18)
                    .onSubmit {
                        fieldInFocus = .password
                    }
                    .submitLabel(SubmitLabel.next)
                    .focused($fieldInFocus ,equals: .email)
                    
                
                SecureField(text: $loginViewHandler.password){
                    Text("Password").foregroundColor(.gray)
                }
                    .font(.system(size:18))
                    .frame(width: 300, height: 20, alignment: .center)
                    .foregroundColor(Color.black)
                    .padding()
                    .background {
                        Color("inputColor")
                    }
                    .cornerRadius(18)
                    .onSubmit {
                        fieldInFocus = nil
                        loginViewHandler.login()
                    }
                    .submitLabel(SubmitLabel.done)
                    .focused($fieldInFocus ,equals: .password)
                
                Button {
                    self.fieldInFocus = nil
                    loginViewHandler.login()
                } label: {
                    if loginViewHandler.isLoading{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .font(.system(size:24))
                            .bold()
                            .frame(width: 300, height: 20, alignment: .center)
                            .foregroundColor(Color.black)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                    }else{
                        HStack{
                            
                            Text("Login")
                            Image(systemName: "arrow.right")
                            
                        }
                        .bold()
                        .font(.system(size:18))
                        .frame(width: 300, height: 20, alignment: .center)
                        .foregroundColor(Color.black)
                        .padding()
                        .background {
                            Color("primaryColor")
                        }
                        .cornerRadius(18)
                    }
                    }
                
                .navigationTitle("Login")
                
                .navigationDestination(isPresented: $loginViewHandler.isLoggedIn) {
                    HomeView()
                }
                .navigationDestination(isPresented: $loginViewHandler.isNotSetUp) {
                    DefaultLanguageView()
                }
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
