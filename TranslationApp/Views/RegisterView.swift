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
    @State private var path = NavigationPath()
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    var body: some View {
        VStack{
            NavigationStack(path: $path){
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
                            self.register()
                        } label: {
                            if registerViewHandler.isSignUpLoading {
                                ActivityIndicator()
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
                        
                        Text("Already have an account?")
                            .padding()
                            .bold()
                            .font(.system(size:18))
                            .foregroundColor(Color("textColor"))
                            .padding()
                            .cornerRadius(18)
                        //Handle Login
                        Navigator(value: "Login", text: "Login")
                    }//Closing V-Stack
                }//Closing Z-Stack
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: String.self){ stringVal in
                    if stringVal == "Login"{
                        LoginView(path: $path) //passed here
                    }else if stringVal == "DefaultLanguage"{
                        DefaultLanguageView(path: $path) //passed here
                    }else if stringVal == "Home"{
                        HomeView(path: $path) //passed here
                    }else if stringVal == "Lyrics"{
                        if let artist = appBrain.lyricsModel.artist, let song = appBrain.lyricsModel.song, let combinedLyrics = appBrain.lyricsModel.combinedLyrics{
                            LyricsView(artist: artist, song: song, combinedLyrics: combinedLyrics, path: $path)
                        }
                    }
                }
              
            }//closing NavigationStack
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .active:
                    print("App is active")
                    handleAutomaticNavigation()
                case .inactive:
                    print("App is inactive")
                case .background:
                    print("App is in background")
                @unknown default:
                    print("Interesting: Unexpected new value.")
                }
            }
            /*VStack{
                Text(String(path.count))
                    .foregroundColor(Color("textColor"))
                    .zIndex(2)
            }*/
        }
    }
    func handleAutomaticNavigation(){
        registerViewHandler.isLoggedIn = false
        if Auth.auth().currentUser != nil {
            let defaultLanguage = defaults.string(forKey: "defaultLanguage")
            let defaultLanguageName = defaults.string(forKey: "defaultLanguageName")
            let requests = defaults.string(forKey: "requests")
            let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
            
            if defaultLanguage != nil, defaultLanguageName != nil, requests != nil, subscriptionPlan != nil{
                appBrain.targetLanguage.language = defaultLanguage!
                appBrain.targetLanguage.name = defaultLanguageName!
                registerViewHandler.isLoggedIn = true
            }else{
                //append register
            }
        }else{
            self.appBrain.handleDeleteLocalStorage()
        }
    }
    func register(){
        self.registerViewHandler.isSignUpLoading = true
        Auth.auth().createUser(withEmail: self.registerViewHandler.email, password: self.registerViewHandler.password) { authResult, error in
            if let e = error{
                print(e.localizedDescription)
            }else{
                print("Registered")
                //Navigate to setDefaultLanguage
                self.path.append("DefaultLanguage")
            }
        }
        self.registerViewHandler.isSignUpLoading = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}


struct ActivityIndicator: View{
    var body: some View{
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
    }
}
struct Navigator: View{
    var value: String
    var text: String
    var body: some View{
        NavigationLink(value: value) {
                Text(text)
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
