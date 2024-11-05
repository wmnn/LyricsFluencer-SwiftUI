//
//  TrialExpiredView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

struct TrialExpiredView: View{
    
    @StateObject var homeViewHandler = HomeViewController()
    @EnvironmentObject var userContext: UserContext
    @FocusState.Binding var fieldInFocus: HomeViewField?
    
    var body: some View {
        
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
            homeViewHandler.handleQuickSearch(searchQuery: homeViewHandler.searchQuery, target: userContext.user!.nativeLanguage ?? "DE")
            fieldInFocus = HomeViewField.none
            self.homeViewHandler.isQuickSearchLoading = true
        }
        .submitLabel(SubmitLabel.done)
        
        TrialExpiredButton(text: "Quick Search")
        
        
    }
}
