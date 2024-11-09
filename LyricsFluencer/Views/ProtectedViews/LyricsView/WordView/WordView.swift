//
//  MenuSubView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

struct WordView: View {
    
    var word : String
    var color : String
    @StateObject var lyricsViewController: LyricsViewController
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var songContext: SongContext
    @EnvironmentObject var userContext: UserContext
    
    var body: some View {
        
        Menu{
            Button {
                lyricsViewController.updateAddToDeckValues(word)
            } label: {
                Text("Add to deck")
            }
            /*Button {
                lyricsViewController.setSelectedWord(word: word)
                lyricsViewController.urlString = "https://www.google.com/search?q=\(lyricsViewController.cleanWord(word))+\(LanguageUtil.getLanguageName(songContext.song.language ?? "EN")?.lowercased() ?? "show")+meaning"
                lyricsViewController.isWebViewShown.toggle()
            } label: {
                Text("Google Meaning")
            }*/
            
            Button {
                self.lyricsViewController.updateGoogleTranslateValues(word)
            } label: {
                Text("Google Translate")
            }
            
            /*
            ForEach(0..<STATIC.languages.count, id: \.self) { i in
                if STATIC.languages[i].language == songContext.song.language ?? "EN"{
                    Button {
                        lyricsViewController.selectedWord = lyricsViewController.cleanWord(word)
                        lyricsViewController.urlString = "https://conjugator.reverso.net/conjugation-\(appBrain.getLanguageName(songContext.song.language ?? "EN")?.lowercased() ?? "english")-verb-\(lyricsViewController.cleanWord(word)).html"
                        lyricsViewController.isWebViewShown.toggle()
           
                    } label: {
                        Text("Show Conjugation (only on Verbs)")
                    }
                }
            }*/
            /*
                Button {
                    lyricsViewController.selectedWord = lyricsViewController.cleanWord(word)
                    lyricsViewController.urlString = "https://conjugator.reverso.net/conjugation-\(appBrain.getLanguageName(appBrain.lyricsModel.detectedLanguage.language)?.lowercased() ?? "english")-verb-\(lyricsViewController.cleanWord(word)).html"
                    lyricsViewController.isWebViewShown.toggle()
       
                } label: {
                    Text("Show Conjugation (only on Verbs)")
                }
            
            */
            
        } label: {
            Text(word)
                .font(.system(size:18))
                .bold()
                .foregroundColor(Color(color))
                .padding(.trailing, 2)
        }
    }
}
