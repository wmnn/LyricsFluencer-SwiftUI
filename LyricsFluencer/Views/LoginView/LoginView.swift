//
//  LoginView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var deckContext: DeckContext
    @EnvironmentObject var userContext: UserContext    
    @StateObject var loginViewController = LoginViewController()

    enum LoginField: Hashable {
        case email
        case password
        case none
    }
    @FocusState var fieldInFocus: LoginField?
    
    var body: some View {
            VStack{
                Spacer()
                TextField(text: self.$loginViewController.email){
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
                
                
                SecureField(text: self.$loginViewController.password){
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
                    loginViewController.login(email: loginViewController.email, password: loginViewController.password)
                }
                .submitLabel(SubmitLabel.done)
                .focused($fieldInFocus ,equals: .password)
                
                SomeButtonWithActivityIndicator(text: "Login", buttonAction: {
                    self.fieldInFocus = LoginField.none
                    self.loginViewController.login(email: loginViewController.email, password: loginViewController.password)
                }, systemName: "arrow.right", binding: $loginViewController.isLoginLoading)
                Spacer()
                SomeButton(text: "Go to Register", buttonAction:{
                    self.appBrain.navigate(to: Views.Register)
                }, systemName: "arrow")
                
                .navigationTitle("Login")
                .navigationBarBackButtonHidden(true)
                .onAppear{
                
                        print("App is active")
                        self.loginViewController.appBrain = self.appBrain
                        self.loginViewController.deckContext = self.deckContext
                        self.loginViewController.userContext = self.userContext
                }
                
            }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
