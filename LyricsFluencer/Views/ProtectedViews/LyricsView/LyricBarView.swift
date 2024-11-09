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
    @StateObject var lyricsViewController: LyricsViewController
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var songContext: SongContext
    
    var body: some View {
        
        let words = LyricsUtil.getWordsFromString(line: bar)
        
        WrappingHStack(alignment: .leading){
            ForEach(0..<words.count, id:\.self){ idx in
                WordView(
                    word: String(words[idx]),
                    color: "textColor",
                    lyricsViewController: lyricsViewController
                )
            }
        }
    }
}

