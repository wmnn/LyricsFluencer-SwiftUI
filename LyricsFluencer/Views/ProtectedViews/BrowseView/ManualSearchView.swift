//
//  ManualSearchView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

struct ManualSearchView: View {
    
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var browseViewController = BrowseViewController()
    @EnvironmentObject var songContext: SongContext
    
    var body: some View {
        TextField(text: $browseViewController.searchQuery){
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

        SomeButtonWithActivityIndicator(text: "Show Results", buttonAction: {
            browseViewController.handleManualSearch()
        }, systemName: "magnifyingglass", binding: $browseViewController.isShowSearchResultsLoading, width: 300)
    }
    
}



