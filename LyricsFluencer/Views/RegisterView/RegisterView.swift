//
//  LoginView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var userContext: UserContext
    @StateObject var registerViewController = RegisterViewController()
    
    var body: some View {
        VStack{
            ZStack{
                Color.background
                    .ignoresSafeArea()
                VStack {
                    TextField(text: $registerViewController.email){
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
                    
                    SecureField(text: $registerViewController.password){
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
                    .onAppear{
                        self.registerViewController.userContext = self.userContext
                    }
                    SomeButtonWithActivityIndicator(text: "Sign Up", buttonAction: {
                        self.registerViewController.register(appBrain: appBrain)
                    }, binding: $registerViewController.isSignUpLoading)
                    
                }//Closing V-Stack
            }//Closing Z-Stack
            .navigationTitle("Register")
        }//closing NavigationStack
        
    }
    
}

struct RegisterView_Preview: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
