//
//  BrowseView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 07.04.23.
//
import SwiftUI

struct BrowseView: View {
    
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var songContext: SongContext
    @StateObject var browseViewController = BrowseViewController()
    
    
    var body: some View {
        ZStack {
            
            GeometryReader { g in
                ScrollView{
                    
                    ManualSearchView(
                        browseViewController: browseViewController
                    )
                    
                    if self.songContext.songResults.count > 1{
                        SomeHeadline(text: "Search Results:", fontSize: 28)
                        
                        Divider()
                        ForEach(Array(songContext.songResults.enumerated()), id: \.offset) { (index, song) in
                            ResultView(
                                song: song,
                                gWidht: g.size.width,
                                idx: index,
                                browseViewController: browseViewController
                            )
                        }
                    }
                    
                    Spacer()
                    SomeHeadline(text: "Popular Songs:", fontSize: 28)
                    Divider()
                    
                    ForEach(Array(songContext.popularSongs.enumerated()), id: \.offset) { (index, song) in
                        ResultView(
                            song: song,
                            gWidht: g.size.width,
                            idx: index,
                            browseViewController: browseViewController
                        )
                    }
                    
                    
                }
                .onAppear{
                    browseViewController.songContext = songContext;
                    if songContext.popularSongs.count == 0 {
                        self.songContext.updatePopularSongs()
                    }
                }
            }
            
            
            if browseViewController.isErrorModalShown {
                
                ErrorModal(
                    isErrorModalShown: $browseViewController.isErrorModalShown,
                    message: browseViewController.errorMessage
                )
            }
        }
        
    }
    
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
