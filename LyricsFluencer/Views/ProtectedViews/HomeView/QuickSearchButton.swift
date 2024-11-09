//
//  QuickSearchButton.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

struct QuickSearchButton: View{
    
    @StateObject var homeViewController = HomeViewController()
    @EnvironmentObject var userContext: UserContext
    @FocusState.Binding var fieldInFocus: HomeViewField?
    
    var body: some View {
        
        HStack{
            SomeButtonWithActivityIndicator(text: "Quick Search", buttonAction: {
                homeViewController.handleQuickSearch();
                fieldInFocus = HomeViewField.none;
            }, systemName: "magnifyingglass", binding: $homeViewController.isQuickSearchLoading, width: 300)
        }
        .frame(width:300)
        
    }
}

