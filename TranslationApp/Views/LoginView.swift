//
//  LoginView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var loginViewHandler = LoginViewHandler()
    enum LoginField: Hashable {
        case email
        case password
        case none
    }
    @FocusState var fieldInFocus: LoginField?
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            
            VStack{
                SomeHeadline(text: "Login", fontSize: 32)
                
                TextField(text: self.$loginViewHandler.email){
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
                    
                
                SecureField(text: self.$loginViewHandler.password){
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
                        loginViewHandler.login(email: loginViewHandler.email, password: loginViewHandler.password)
                    }
                    .submitLabel(SubmitLabel.done)
                    .focused($fieldInFocus ,equals: .password)
                
                SomeButtonWithActivityIndicator(text: "Login", buttonAction: {
                    self.fieldInFocus = LoginField.none
                    self.loginViewHandler.login(email: loginViewHandler.email, password: loginViewHandler.password)
                }, systemName: "arrow.right", binding: $loginViewHandler.isLoginLoading)
                
                .navigationTitle("Login")
                .onAppear{
                    self.loginViewHandler.appBrain = self.appBrain
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
