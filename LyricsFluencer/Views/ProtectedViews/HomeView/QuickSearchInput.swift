//
//  QuickSearchInput.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

struct QuickSearchInput: View{
    
    @EnvironmentObject var userContext: UserContext
    @StateObject var homeViewHandler = HomeViewController()
    @FocusState.Binding var fieldInFocus: HomeViewField?
    
    var body: some View {
        
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
            } else {
                if !homeViewHandler.isShazamLoading{
                    homeViewHandler.handleQuickSearch()
                    fieldInFocus = HomeViewField.none
                }
            }
        }
        .submitLabel(SubmitLabel.done)
        
    }
}
