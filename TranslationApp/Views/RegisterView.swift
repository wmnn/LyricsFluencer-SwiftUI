//
//  ContentView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RegisterView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var registerViewHandler = RegisterViewHandler()
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    var body: some View {
        NavigationStack() {
            ZStack{
                Color("appColor")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Learn languages with lyrics translations !")
                        .padding()
                        .frame(width: 300, height: 20, alignment: .center)
                        .bold()
                        .font(.system(size:32))
                        .foregroundColor(Color("textColor"))
                        .padding()
                        .cornerRadius(18)
                    
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
                    
                    Button {
                        registerViewHandler.register()
                    } label: {
                        if registerViewHandler.isSignUpLoading {
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
                            Text("Sign Up")
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
                    .navigationDestination(isPresented: $registerViewHandler.isRegistered) {
                        DefaultLanguageView()
                    }
                    .navigationDestination(isPresented: $registerViewHandler.isLoggedIn) {
                        HomeView()
                    }
                    .navigationDestination(isPresented: $registerViewHandler.isLoginClicked) {
                        LoginView()
                    }
                    
                    Text("Already have an account?")
                        .padding()
                        .bold()
                        .font(.system(size:18))
                        .foregroundColor(Color("textColor"))
                        .padding()
                        .cornerRadius(18)
                    //Handle Login
                    Button {
                        registerViewHandler.isLoginClicked.toggle()
                    } label: {
                            Text("Login")
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
                        
                    
                    /*
                    NavigationLink(destination: LoginView()) {
                        HStack{
                            Text("Go to Login")
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
                    */
                    
                }//Closing H-Stack
            }//Closing Z-Stack
            .navigationBarBackButtonHidden(true)
        }//closing NavigationStack
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App is active")
                registerViewHandler.isLoginClicked = false
                handleAutomaticNavigation()
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                print("Interesting: Unexpected new value.")
            }
        }
        
        
    }
    func handleAutomaticNavigation(){
        if Auth.auth().currentUser != nil {
            let defaultLanguage = defaults.string(forKey: "defaultLanguage")
            let defaultLanguageName = defaults.string(forKey: "defaultLanguageName")
            let requests = defaults.string(forKey: "requests")
            let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
            
            if defaultLanguage != nil, defaultLanguageName != nil, requests != nil, subscriptionPlan != nil{
                appBrain.targetLanguage.language = defaultLanguage!
                appBrain.targetLanguage.name = defaultLanguageName!
                appBrain.handleTrial()
                DispatchQueue.main.async {
                    registerViewHandler.isLoggedIn.toggle()
                }
            }else{
                //registerViewHandler.isRegistered = true
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

