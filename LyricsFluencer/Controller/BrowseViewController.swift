//
//  BrowseViewController.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 07.04.23.
//

import Foundation

class BrowseViewController: ObservableObject {
    
    @Published var isShowSearchResultsLoading : Bool = false
    @Published var searchQuery : String = ""
    @Published var songContext: SongContext?
    
    func handleManualSearch() {
        self.isShowSearchResultsLoading = true
        songContext?.handleManualSearch(searchQuery: searchQuery) { songs, error in
            
            guard error == nil && songs != nil else {
                print("handleManualSearch Error, inside browse view controller")
                self.isShowSearchResultsLoading = false;
                return;
            }
            
            self.isShowSearchResultsLoading = false;
        }
    }
}
