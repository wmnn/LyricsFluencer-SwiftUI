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
    
    @StateObject var homeViewHandler = HomeViewController()
    
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
                        homeViewHandler.handleShazam()
                    }, systemName: "shazam.logo.fill", binding: $homeViewHandler.isShazamLoading)
                    
                    QuickSearchInput(
                        homeViewHandler: self.homeViewHandler,
                        fieldInFocus: self.$fieldInFocus
                    )
                    
                    QuickSearchButton(
                        homeViewHandler: self.homeViewHandler,
                        fieldInFocus: self.$fieldInFocus
                    )
                
                // }
                SomeButton(text: "Browse Songs") {
                    self.appContext.path.append("Browse")
                }
                //Flashcard
                SomeButton(text: "Your Flashcards") {
                    self.appContext.path.append("Flashcards")
                }
            }//Closing VStack
        }//Closing ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu{
                    Button("Settings") {
                        self.appContext.path.append("Settings")
                    }
                    Button("Logout") {
                        userContext.logout{ error in
                            guard error == nil else {
                                return;
                            }
                            DispatchQueue.main.async{
                                appContext.path = NavigationPath()
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
            self.homeViewHandler.appBrain = self.appContext
            self.homeViewHandler.songContext = self.songContext
            self.homeViewHandler.userContext = self.userContext
            if deckContext.decks.count == 0 {
                self.deckContext.fetchingDecks()
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
