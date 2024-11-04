//
//  BrowseView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 07.04.23.
//

import SwiftUI

struct BrowseView: View {
    
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var browseViewController = BrowseViewController()
    @EnvironmentObject var songContext: SongContext
    
    var body: some View {
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
        
    }
    
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
