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
                    Color.background
                        .ignoresSafeArea()
                    VStack {
                        Text("LyricsFluencer")
                            .lineLimit(nil)
                            //.fixedSize(horizontal: false, vertical: true)
                            .frame(width: 300, alignment: .center)
                            .bold()
                            .font(.system(size: 36))
                            .foregroundColor(Color.text)
                            .cornerRadius(18)
                        Text("Learn languages with lyrics !")
                            .lineLimit(nil)
                            //.fixedSize(horizontal: false, vertical: true)
                            .frame(width: 350, alignment: .center)
                            .bold()
                            .font(.system(size: 24))
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
                        
                        SomeButtonWithActivityIndicator(text: "Sign Up", buttonAction: {
                            self.registerViewHandler.register(appBrain: appBrain)
                        }, binding: $registerViewHandler.isSignUpLoading)
                        
                        SomeHeadline(text: "Already have an account?", fontSize: 18)
                        //Handle Login
                        SomeButton(text: "Go to Login", buttonAction:{
                            self.appBrain.path.append("Login")
                        }, systemName: "arrow")
                        
                    }//Closing V-Stack
                }//Closing Z-Stack
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: String.self){ stringVal in
                    switch stringVal {
                    case "Login":
                        LoginView()
                    case "DefaultLanguage":
                        DefaultLanguageView()
                    case "Home":
                        HomeView()
                    case "Lyrics":
                        LyricsView()
                    case "Flashcards":
                        DecksView()
                    case "DeckSettingsView":
                        DeckSettingsView()
                    case "CardsView":
                        CardView()
                    case "EditCardsView":
                        EditCardsView()
                    case "Settings":
                        SettingsView()
                    default:
                        RegisterView()
                    }
                }
                
            }//closing NavigationStack
            .onAppear{
                print("App is active")
                //self.registerViewHandler.handleAutoLogin(appBrain: appBrain)
                //If we do auto login here, we got some wierd bugs
            }
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .active:
                    print("App is active")
                    self.registerViewHandler.handleAutoLogin(appBrain: appBrain)
                case .inactive:
                    print("App is inactive")
                case .background:
                    print("App is in background")
                @unknown default:
                    print("Interesting: Unexpected new value.")
                }
            }
            ZStack{ //For testing
                VStack{
                    Text("\(appBrain.path.count)")
                        .foregroundColor(Color.black)
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

struct SomeHeadline: View{
    var text: String
    var fontSize: CGFloat
    var body: some View{
        Text(text)
            .lineLimit(nil)
            //.fixedSize(horizontal: false, vertical: true)
            .frame(width: 300, alignment: .center)
            .bold()
            .font(.system(size: fontSize))
            .foregroundColor(Color("textColor"))
            .padding()
            .cornerRadius(18)
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
    var systemName: String?
    
    var body: some View{
        Button {
            buttonAction()
        } label: {
            if systemName == nil {
                TextWithIcon(text: text, systemName: "")
            }else{
                TextWithIcon(text: text, systemName: systemName ?? "")
            }
        }
    }
}
struct SomeButtonWithActivityIndicator: View{
    var text: String
    let buttonAction: () -> Void
    var systemName: String?
    @Binding var binding: Bool
    
    var body: some View{
        Button {
            buttonAction()
        } label: {
            if self.binding{
                ActivityIndicator()
            }else{
                if systemName == nil {
                    TextWithIcon(text: text, systemName: "")
                }else{
                    TextWithIcon(text: text, systemName: systemName!)
                }
            }
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
        .foregroundColor(Color.white)
        .padding()
        .background {
            Color("primaryColor")
        }
        .cornerRadius(18)
        
    }
}
struct SomeTextField: View{
    @Binding var binding: String
    var placeholder: String
    
    var body: some View{
        TextField(text: $binding){
            Text(placeholder).foregroundColor(.gray)
        }
        .font(.system(size:18))
        .frame(width: 300, height: 20, alignment: .center)
        .foregroundColor(Color.black)
        .padding()
        .background {
            Color("inputColor")
        }
        .cornerRadius(18)
        .disableAutocorrection(true)
        .autocapitalization(.none)
    }
}
struct SomeSmallButton: View{
    var text: String
    let buttonAction: () -> Void
    var textColor: Color
    var body: some View{
        Button {
            buttonAction()
        } label: {
            Text(text)
                .font(.system(size:24))
                .bold()
                .frame(width: 120, height: 20, alignment: .center)
                .foregroundColor(textColor)
                .padding()
                .background {
                    Color("primaryColor")
                }
                .cornerRadius(18)

        }
    }
}
