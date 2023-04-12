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
    @Environment(\.scenePhase) var scenePhase
    enum LoginField: Hashable {
        case email
        case password
        case none
    }
    @FocusState var fieldInFocus: LoginField?
    
    var body: some View {
        VStack{
            NavigationStack(path: $appBrain.path){
                ZStack{
                    Color.background
                        .ignoresSafeArea()
                    VStack{
                        Spacer()
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
                        Spacer()
                        SomeButton(text: "Go to Register", buttonAction:{
                            self.appBrain.path.append("Register")
                        }, systemName: "arrow")
                        
                        .navigationTitle("Login")
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
                            case "Browse":
                                BrowseView()
                            case "Register":
                                RegisterView()
                            default:
                                LoginView()
                            }
                        }
                        .onChange(of: scenePhase) { newScenePhase in
                            switch newScenePhase {
                            case .active:
                                print("App is active")
                                self.loginViewHandler.appBrain = self.appBrain
                                self.loginViewHandler.handleAutoLogin()
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
        }
    }    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
