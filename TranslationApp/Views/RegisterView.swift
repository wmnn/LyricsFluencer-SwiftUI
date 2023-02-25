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
    
    var body: some View {
        VStack{
            NavigationStack(path: $appBrain.path){
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
                            self.registerViewHandler.register(appBrain: appBrain)
                        } label: {
                            if registerViewHandler.isSignUpLoading {
                                ActivityIndicator()
                            }else{
                                TextWithIcon(text: "Sign Up", systemName: "")
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
                        Button {
                            self.appBrain.path.append("Login")
                        } label: {
                            TextWithIcon(text: "Go to Login", systemName: "")
                        }
                    }//Closing V-Stack
                }//Closing Z-Stack
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: String.self){ stringVal in
                    if stringVal == "Login"{
                        LoginView() //passed here
                    }else if stringVal == "DefaultLanguage"{
                        DefaultLanguageView() //passed here
                    }else if stringVal == "Home"{
                        HomeView() //passed here
                    }else if stringVal == "Lyrics"{
                        if let artist = appBrain.lyricsModel.artist, let song = appBrain.lyricsModel.song, let combinedLyrics = appBrain.lyricsModel.combinedLyrics{
                            LyricsView(artist: artist, song: song, combinedLyrics: combinedLyrics)
                        }
                    }else if stringVal == "Flashcards"{
                        DecksView()
                    }else if stringVal == "DeckSettingsView"{
                        DeckSettingsView()
                    }else if stringVal == "CardsView"{
                        CardView()
                    }else if stringVal == "EditCardsView"{
                        EditCardsView()
                    }
                }
              
            }//closing NavigationStack
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .active:
                    print("App is active")
                    self.registerViewHandler.handleAutomaticNavigation(appBrain: appBrain)
                case .inactive:
                    print("App is inactive")
                case .background:
                    print("App is in background")
                @unknown default:
                    print("Interesting: Unexpected new value.")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let appBrain = AppBrain()
    static var previews: some View {
        RegisterView()
            .environmentObject(appBrain)
    }
}


struct ActivityIndicator: View{
    var body: some View{
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .font(.system(size:24))
            .bold()
            .frame(width: 300, height: 20, alignment: .center)
            .foregroundColor(Color("textColor"))
            .padding()
            .background {
                Color("primaryColor")
            }
            .cornerRadius(18)
    }
}

struct SomeButton: View{
    var text: String
    let buttonAction: () -> Void
    
    var body: some View{
        Button {
            buttonAction()
        } label: {
            Text(text)
                .bold()
                .font(.system(size:24))
                .frame(width: 300, height: 20, alignment: .center)
                .foregroundColor(Color("textColor"))
                .padding()
                .background {
                    Color("primaryColor")
                }
                .cornerRadius(18)
        }
        
    }
}
struct TextWithIcon: View{
    var text: String
    var systemName: String
    var body: some View{
        HStack{
            Text(text)
            Image(systemName: systemName)
        }
        .bold()
        .font(.system(size:24))
        .frame(width: 300, height: 20, alignment: .center)
        .foregroundColor(Color("textColor"))
        .padding()
        .background {
            Color("primaryColor")
        }
        .cornerRadius(18)
        
    }
}
