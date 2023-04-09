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
    
    var body: some View {
        GeometryReader { g in
            ScrollView{
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
                    browseViewController.handleSearch()
                }, systemName: "magnifyingglass", binding: $browseViewController.isShowSearchResultsLoading, width: 300)
                
                if browseViewController.searchResults.count > 1{
                    SomeHeadline(text: "Search Results:", fontSize: 28)
                    
                    Divider()
                    ForEach(Array(browseViewController.searchResults.enumerated()), id: \.offset) { (index, song) in
                        Button {
                            print(song)
                            browseViewController.handleSelectedSong(commontrack_id: song.track.commontrack_id)
                            appBrain.lyricsModel.artist = song.track.artist_name
                            appBrain.lyricsModel.song = song.track.track_name
                            
                        } label: {
                            HStack{
                                VStack{
                                    Text("\(index + 1)")
                                        .bold()
                                        .padding(.leading)
                                    
                                }
                                .padding()
                                VStack{
                                    Text("Song: \(song.track.track_name)")
                                        .foregroundColor(Color.text)
                                    
                                        .frame(maxWidth: g.size.width - 5, maxHeight: .infinity)
                                    Text("Artist: \(song.track.artist_name)")
                                        .foregroundColor(Color.text)
                                    
                                        .frame(maxWidth: g.size.width - 5, maxHeight: .infinity)
                                    
                                }
                            }
                        }
                        Divider()
                    }
                }
                Spacer()
                
                SomeHeadline(text: "Popular Songs:", fontSize: 28)
                
                Divider()
                ForEach(Array(browseViewController.popularSongs.enumerated()), id: \.offset) { (index, song) in
                    Button {
                        print(song)
                        browseViewController.handleSelectedSong(commontrack_id: song.track.commontrack_id)
                        appBrain.lyricsModel.artist = song.track.artist_name
                        appBrain.lyricsModel.song = song.track.track_name
                        
                    } label: {
                        HStack{
                            VStack{
                                Text("\(index + 1)")
                                    .bold()
                                    .padding(.leading)
                                
                            }
                            .padding()
                            VStack{
                                Text("Song: \(song.track.track_name)")
                                    .foregroundColor(Color.text)
                                
                                    .frame(maxWidth: g.size.width - 5, maxHeight: .infinity)
                                Text("Artist: \(song.track.artist_name)")
                                    .foregroundColor(Color.text)
                                
                                    .frame(maxWidth: g.size.width - 5, maxHeight: .infinity)
                                
                            }
                        }
                    }
                    Divider()
                }
                
                
            }
            .onAppear{
                self.browseViewController.appBrain = self.appBrain
                if browseViewController.popularSongs.count == 0{
                    self.browseViewController.fetchPopularSongs()
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
