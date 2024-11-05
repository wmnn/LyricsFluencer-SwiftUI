//
//  QuickSearchButton.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

struct QuickSearchButton: View{
    
    @StateObject var homeViewHandler = HomeViewController()
    @EnvironmentObject var userContext: UserContext
    @FocusState.Binding var fieldInFocus: HomeViewField?
    
    var body: some View {
        
        HStack{
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
                            homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: userContext.user!.nativeLanguage ?? "DE")
                            fieldInFocus = HomeViewField.none
                        }
                    }
                }
            }, systemName: "magnifyingglass", binding: $homeViewHandler.isQuickSearchLoading, width: 300)
        }
        .frame(width:300)
        
    }
}

