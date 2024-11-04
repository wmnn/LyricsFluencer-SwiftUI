//
//  LyricsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import Foundation
import WrappingHStack
import WebKit
import FirebaseFirestore

struct LyricsView: View {
    
    @EnvironmentObject var appBrain: AppBrain
    @EnvironmentObject var songContext: SongContext
    @StateObject var lyricsViewHandler = LyricsViewHandler()
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea(.all)
                ScrollView{
                    
                    VStack(alignment: .leading){
                        
                        Title(text: "Artist: \(songContext.song.artist ?? " ")")
                        Title(text: "Song: \(songContext.song.name ?? " ")")
                            .padding(.bottom)
                        
                        ForEach(0..<self.songContext.song.lyrics!.count, id: \.self) { idx in
                                LyricBarView(
                                    bar: self.songContext.song.lyrics![idx],
                                    lyricsViewHandler: lyricsViewHandler
                                )
                                
                                
                                if self.songContext.song.translation!.count > idx {
                                    TranslationBarView(
                                        bar: self.songContext.song.translation![idx],
                                        lyricsViewHandler: lyricsViewHandler
                                    )
                                }
                        }
                        
                        
                    }//Closing VStack
                }//Closing Scroll View
                if lyricsViewHandler.isAddToDeckViewShown || lyricsViewHandler.isWebViewShown{
                    ZStack{
                        VisualEffectView(effect: UIBlurEffect(style: .dark))
                        Color.black.opacity(0.4).ignoresSafeArea(.all)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                if lyricsViewHandler.isAddToDeckViewShown{
                    AddWordView(lyricsViewHandler: lyricsViewHandler)
                }
                if lyricsViewHandler.isWebViewShown {
                    PopUpWebView(lyricsViewHandler: lyricsViewHandler)
                }
                
            }//Closing ZStack
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    if !lyricsViewHandler.isWebViewShown && !lyricsViewHandler.isAddToDeckViewShown{
                        Button {
                            self.lyricsViewHandler.isWebViewShown = false
                            // appBrain.lyricsModel.albumArtURL = nil
                            appBrain.path.removeLast()
                        } label: {
                            HStack{
                                Image(systemName: "arrow.left")
                                Text("Back")
                                    .font(.system(size: 24))
                            }
                        }
                    }
                }
            }//toolbar
        
    }//View
}//struct

struct LyricsView_Previews: PreviewProvider {

    static var previews: some View {
        LyricsView()

    }
}

struct Title: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 24))
            .bold()
    }
}
