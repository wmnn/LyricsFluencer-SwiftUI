//
//  LoggedInHomeView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import ReplayKit

struct HomeView: View{
    
    @EnvironmentObject var appBrain: AppBrain
    @EnvironmentObject var songContext: SongContext
    @StateObject var homeViewHandler = HomeViewController()
    enum HomeViewField: Hashable {
        case search
        case none
    }
    @FocusState var fieldInFocus: HomeViewField?
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                if appBrain.user.isTrialExpired{
                    SomeHeadline(text: "Your free trial has expired, unfortunately you can't subscribe inside the app.", fontSize: 24)
                    TrialExpiredButton(text: "Recognize Song")
                    //handling Quicksearch Input
                    TextField(text: $homeViewHandler.searchQuery){
                        Text("Search").foregroundColor(Color.gray)
                    }
                    .font(.system(size:24))
                    .frame(width: 300, height: 20, alignment: .center)
                    .padding()
                    .foregroundColor(Color.black)
                    .background{
                        Color("inputColor")
                    }
                    .cornerRadius(18)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .onSubmit {
                        homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: appBrain.user.nativeLanguage.language)
                        fieldInFocus = HomeViewField.none
                        self.homeViewHandler.isQuickSearchLoading = true
                    }
                    .submitLabel(SubmitLabel.done)
                    
                    TrialExpiredButton(text: "Quick Search")
                }else{
                    //Handling languages
                    LanguagesMenu(binding: self.$appBrain.user.learnedLanguage, title: "Learned Language:")
                    LanguagesMenu(binding: self.$appBrain.user.nativeLanguage, title: "Your Language:")
                            
                    //handling Shazam
                    SomeButtonWithActivityIndicator(text: "Recognize Song ", buttonAction: {
                        homeViewHandler.handleShazam()
                    }, systemName: "shazam.logo.fill", binding: $homeViewHandler.isShazamLoading)
                    
                    //handling Quicksearch Input
                    //HomeViewSearchInput(homeViewHandler: homeViewHandler)
                    TextField(text: $homeViewHandler.searchQuery){
                        Text("Search").foregroundColor(Color.gray)
                    }
                    .font(.system(size:24))
                    .frame(width: 300, height: 20, alignment: .center)
                    .padding()
                    .foregroundColor(Color.black)
                    .background{
                        Color("inputColor")
                    }
                    .cornerRadius(18)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .onSubmit {
                        if self.homeViewHandler.isQuickSearchLoading{
                            fieldInFocus = HomeViewField.none
                            DispatchQueue.main.async {
                                self.homeViewHandler.isQuickSearchLoading = false
                                self.homeViewHandler.isShazamLoading = false
                            }
                        }else{
                            print("Else")
                            if !homeViewHandler.isShazamLoading{
                                homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: appBrain.user.nativeLanguage.language)
                                fieldInFocus = HomeViewField.none
                            }
                        }
                    }
                    .submitLabel(SubmitLabel.done)
                    
                    HStack{/*
                        SomeButtonWithActivityIndicator(text: "Manual Search", buttonAction: {
                          
                        }, systemName: "magnifyingglass",binding: $homeViewHandler.isQuickSearchLoading, width: 300/2)
                        */
                        SomeButtonWithActivityIndicator(text: "Quick Search", buttonAction: {
                            if self.homeViewHandler.isQuickSearchLoading {
                                fieldInFocus = HomeViewField.none
                                DispatchQueue.main.async {
                                    self.homeViewHandler.isQuickSearchLoading = false
                                    self.homeViewHandler.isShazamLoading = false
                                }
                            } else {
                                if !homeViewHandler.isShazamLoading{
                                    DispatchQueue.main.async {
                                        self.homeViewHandler.isQuickSearchLoading = true
                                        print("Calling inside HomeView handleQuickSearch")
                                        homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: appBrain.user.nativeLanguage.language)
                                        fieldInFocus = HomeViewField.none
                                    }
                                }
                            }
                        }, systemName: "magnifyingglass", binding: $homeViewHandler.isQuickSearchLoading, width: 300)
                    }
                    .frame(width:300)
                
                }
                SomeButton(text: "Browse Songs") {
                    self.appBrain.path.append("Browse")
                }
                //Flashcard
                SomeButton(text: "Your Flashcards") {
                    self.appBrain.path.append("Flashcards")
                }
            }//Closing VStack
        }//Closing ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu{
                    Button("Settings") {
                        self.appBrain.path.append("Settings")
                    }
                    Button("Logout") {
                        appBrain.logout()
                    }
                }label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color.text)
                }
            }
        }
        .onAppear{
            appBrain.handleTrial()
            appBrain.checkSubscriptionPlan()
            self.homeViewHandler.appBrain = self.appBrain
            self.homeViewHandler.songContext = self.songContext
        }
    }
}

struct LoggedInHomeView_Previews: PreviewProvider {
    static let appBrain = AppBrain()
    static var previews: some View {
        HomeView()
            .environmentObject(appBrain)
    }
}

struct TrialExpiredButton: View{
    var text: String
    var body: some View{
        HStack{
            Text(text)
            Image(systemName: "lock")
        }
        .font(.system(size:24))
        .bold()
        .frame(width: 300, height: 20, alignment: .center)
        .foregroundColor(Color.black)
        .padding()
        .background {
            Color.gray
        }
        .cornerRadius(18)
    }
}

struct LanguagesMenu: View{
    @EnvironmentObject var appBrain: AppBrain
    @Binding var binding : Language
    var title: String
    
    var body: some View{
        Menu{
            ForEach(0..<STATIC.languages.count, id: \.self) { index in
                Button {
                    binding.language = STATIC.languages[index].language
                    //appBrain.user.nativeLanguage.language = STATIC.languages[index].language

                } label: {
                    Text(STATIC.languages[index].name!)
                }
            }
        } label: {
            Label(
                title: {Text("\(title) \(self.appBrain.getLanguageName(binding.language) ?? "")")
                        .font(.system(size:24))
                        .bold()
                        .frame(width: 300, height: 20, alignment: .center)
                        .foregroundColor(Color.white)
                        .padding()
                        .background {
                            Color("primaryColor")
                        }
                        .cornerRadius(18)
                },
                icon: { Image(systemName: "")}
            )
        }
        
    }
}

/*
struct HomeViewSearchInput: View{
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var homeViewHandler: HomeViewHandler
    @Binding var focusState: HomeViewField
    
    var body: some View{
        TextField(text: $homeViewHandler.searchQuery){
            Text("Search").foregroundColor(Color.gray)
        }
        .font(.system(size:24))
        .frame(width: 300, height: 20, alignment: .center)
        .padding()
        .foregroundColor(Color.black)
        .background{
            Color("inputColor")
        }
        .cornerRadius(18)
        .autocapitalization(.none)
        .autocorrectionDisabled(true)
        .onSubmit {
            homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: appBrain.user.targetLanguage.language)
        }
        .submitLabel(SubmitLabel.done)
    }
}
*/
