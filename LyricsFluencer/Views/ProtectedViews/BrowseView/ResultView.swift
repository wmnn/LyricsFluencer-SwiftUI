//
//  ResultView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

/**
    Represents a search result or a popular song
 */
struct ResultView: View {
    
    var song: Song
    var gWidht: CGFloat
    var idx: Int
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var userContext: UserContext
    @StateObject var browseViewController = BrowseViewController()
    @EnvironmentObject var songContext: SongContext
    
    var body: some View {
        
        Button {
            print("Clicked on song, ", song)
            songContext.handleSelectedSong(song: song, nativeLanguage: userContext.user!.nativeLanguage ?? "") {_ in
                DispatchQueue.main.async {
                    self.appBrain.navigate(to: Views.Lyrics)
                }
            }
            
        } label: {
            HStack{
                VStack{
                    Text("\(idx + 1)")
                        .bold()
                        .padding(.leading)
                    
                }
                .padding()
                VStack{
                    Text("Song: \(song.name!)")
                        .foregroundColor(Color.text)
                        .frame(maxWidth: CGFloat(gWidht - 5), maxHeight: .infinity)
                    
                    Text("Artist: \(song.artist!)")
                        .foregroundColor(Color.text)
                        .frame(maxWidth: CGFloat(gWidht - 5), maxHeight: .infinity)
                    
                }
            }
        }
        Divider()
        
    }
    
}
