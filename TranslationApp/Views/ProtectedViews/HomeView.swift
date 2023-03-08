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
    //@State private var homePath = NavigationPath()
    @StateObject var homeViewHandler = HomeViewHandler()
    /*@State var isRecording: Bool = false
    @State var url: URL?*/
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                if appBrain.isTrialExpired {
                    SomeHeadline(text: "Your free trial has expired, unfortunately you can't subscribe inside the app.", fontSize: 24)
                    TrialExpiredButton(text: "Recognize Song")
                    //handling Quicksearch Input
                    HomeViewSearchInput(homeViewHandler: homeViewHandler)
                    TrialExpiredButton(text: "Quick Search")
                }else{
                    /*Text(homeViewHandler.shazamMedia.title ?? "")
                    AsyncImage(url: homeViewHandler.shazamMedia.albumArtURL){
                        image in
                        image
                            .resizable()
                            .scaledToFit()
                            //.blur(radius:10, opaque: true)
                            .opacity(0.5)
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        EmptyView()
                    }*/
                    //Handling target language
                    LanguagesMenu()
                    //handling Shazam
                    SomeButtonWithActivityIndicator(text: "Recognize Song ", buttonAction: {
                        homeViewHandler.handleShazam()
                        homeViewHandler.isShazamLoading = true
                        /*homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.shazamMedia.title ?? "", target: appBrain.targetLanguage.language, appBrain: appBrain)*/
                    }, systemName: "shazam.logo.fill", binding: $homeViewHandler.isShazamLoading)
                    
                    //handling Quicksearch Input
                    HomeViewSearchInput(homeViewHandler: homeViewHandler)
                    
                    SomeButtonWithActivityIndicator(text: "Quick Search", buttonAction: {
                        homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: appBrain.targetLanguage.language, appBrain: appBrain)
                        self.homeViewHandler.isQuickSearchLoading = true
                    }, systemName: "magnifyingglass",binding: $homeViewHandler.isQuickSearchLoading)
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
        .onAppear(perform: {
            appBrain.handleTrial()
            appBrain.checkSubscriptionPlan()
            //self.homeViewHandler.setup(self.appBrain)
        })
        .onChange(of: homeViewHandler.didShazamRecognizeSong) { newVal in
            DispatchQueue.main.async {
                if newVal{
                    print(newVal)
                    homeViewHandler.handleQuickSearch(searchQuery: (homeViewHandler.shazamMedia.title ?? "") + " " + (homeViewHandler.shazamMedia.artistName ?? ""), target: self.appBrain.targetLanguage.language, appBrain: self.appBrain)
                }else{
                    print("Not true")
                }
                
            }
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
    
    var body: some View{
        Menu{
            ForEach(0..<STATIC.languages.count, id: \.self) { index in
                Button {
                    appBrain.targetLanguage.language = STATIC.languages[index].language
                    appBrain.targetLanguage.name = STATIC.languages[index].name
                } label: {
                    Text(STATIC.languages[index].name)
                }
            }
        } label: {
            Label(
                title: {Text("Target language: \(appBrain.targetLanguage.name)")
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

struct HomeViewSearchInput: View{
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var homeViewHandler: HomeViewHandler
    
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
            homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: appBrain.targetLanguage.language, appBrain: appBrain)
        }
        .submitLabel(SubmitLabel.done)
    }
}
