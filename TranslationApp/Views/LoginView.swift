//
//  LoginView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    //@Binding var path: NavigationPath
    
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
                TextField(text: $email){
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
                SecureField(text: $password){
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
                
                Button {
                    login()
                } label: {
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
                .navigationTitle("Login")
                
                .navigationDestination(isPresented: $isLoggedIn) {
                    LoggedInHomeView()
                    Text("")
                        .hidden()
                }
            }
        }
    }
    func login(){
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            }else{
                //Make an api call which call is active
                
                //Navigate
                self.isLoggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
