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

/**
 Needed for FocusState
 */
enum HomeViewField: Hashable {
    case search
    case none
}

struct HomeView: View{
    
    @EnvironmentObject var appContext: AppContext
    @EnvironmentObject var songContext: SongContext
    @EnvironmentObject var userContext: UserContext
    @EnvironmentObject var deckContext: DeckContext
    
    @StateObject var homeViewController = HomeViewController()
    
    @FocusState var fieldInFocus: HomeViewField?
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                /*if userContext.user?.isTrialExpired ?? false {
                    TrialExpiredView(
                        homeViewHandler: self.homeViewHandler,
                        fieldInFocus: self.$fieldInFocus
                    )
                } else {*/
                
                    //handling Shazam
                    SomeButtonWithActivityIndicator(text: "Recognize Song ", buttonAction: {
                        homeViewController.handleShazam()
                    }, systemName: "shazam.logo.fill", binding: $homeViewController.isShazamLoading)
                    
                    QuickSearchInput(
                        homeViewHandler: self.homeViewController,
                        fieldInFocus: self.$fieldInFocus
                    )
                    
                    QuickSearchButton(
                        homeViewController: self.homeViewController,
                        fieldInFocus: self.$fieldInFocus
                    )
                
                // }
                SomeButton(text: "Browse Songs") {
                    self.appContext.navigate(to: Views.Browse)
                }
                //Flashcard
                SomeButton(text: "Your Flashcards") {
                    self.appContext.navigate(to: Views.Flashcards)
                }
                
            }//Closing VStack
            
            if homeViewController.isErrorModalShown {
                
                ErrorModal(
                    isErrorModalShown: $homeViewController.isErrorModalShown,
                    message: homeViewController.errorMessage
                )
            }
            
        }//Closing ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu{
                    Button("Settings") {
                        self.appContext.navigate(to: Views.Settings)
                    }
                    Button("Logout") {
                        userContext.logout{ error in
                            guard error == nil else {
                                homeViewController.errorMessage = "Couldn't log out user."
                                homeViewController.isErrorModalShown = true
                                return;
                            }
                            DispatchQueue.main.async{
                                appContext.resetNavigationPath()
                            }
                        }
                    }
                }label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color.text)
                }
            }
        }
        .onAppear{
            self.homeViewController.appBrain = self.appContext
            self.homeViewController.songContext = self.songContext
            self.homeViewController.userContext = self.userContext
            if deckContext.decks.count == 0 {
                self.deckContext.fetchingDecks { decks in
                    guard decks == nil else {
                        return;
                    }
                    DispatchQueue.main.async {
                        homeViewController.errorMessage = "Couldn't connect to server."
                        homeViewController.isErrorModalShown = true
                    }
                    
                    
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let appBrain = AppContext()
    static var previews: some View {
        HomeView()
            .environmentObject(appBrain)
    }
}
