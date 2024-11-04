//
//  LyricBarView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI
import WrappingHStack

struct LyricBarView: View {
    
    var bar : String
    @StateObject var lyricsViewHandler: LyricsViewHandler
    @EnvironmentObject var appBrain: AppBrain
    @EnvironmentObject var songContext: SongContext
    
    var body: some View {
        
        let words = lyricsViewHandler.handleSplittingLine(line: bar)
        
        WrappingHStack(alignment: .leading){
            ForEach(0..<words.count, id:\.self){ idx in
                WordView(
                    word: String(words[idx]),
                    color: "textColor",
                    lyricsViewHandler: lyricsViewHandler
                )
            }
        }
    }
}

