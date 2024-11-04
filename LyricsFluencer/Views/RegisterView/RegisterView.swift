//
//  LoginView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var registerViewHandler = RegisterViewHandler()
    
    var body: some View {
        VStack{
            ZStack{
                Color.background
                    .ignoresSafeArea()
                VStack {
                    TextField(text: $registerViewHandler.email){
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
                    
                    SecureField(text: $registerViewHandler.password){
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
                    SomeButtonWithActivityIndicator(text: "Sign Up", buttonAction: {
                        self.registerViewHandler.register(appBrain: appBrain)
                    }, binding: $registerViewHandler.isSignUpLoading)
                    
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
