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
    @StateObject var lyricsViewHandler: LyricsViewHandler
    @EnvironmentObject var appBrain: AppBrain
    @EnvironmentObject var songContext: SongContext
    
    var body: some View {
        
        Menu{
            Button {
                lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                lyricsViewHandler.front = ""
                lyricsViewHandler.back = lyricsViewHandler.cleanWord(word)
                lyricsViewHandler.urlString = "https://www.google.com/search?q=\(lyricsViewHandler.cleanWord(word))+\(appBrain.getLanguageName(songContext.song.detectedLanguage ?? "EN")?.lowercased() ?? "show")+meaning"
                lyricsViewHandler.isAddToDeckViewShown.toggle()
            } label: {
                Text("Add to deck")
            }
            Button {
                lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                lyricsViewHandler.urlString = "https://www.google.com/search?q=\(lyricsViewHandler.cleanWord(word))+\(appBrain.getLanguageName(songContext.song.detectedLanguage ?? "EN")?.lowercased() ?? "show")+meaning"
                lyricsViewHandler.isWebViewShown.toggle()
            } label: {
                Text("Google Meaning")
            }
            
            Button {
                lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                print("https://translate.google.com/?sl=\(songContext.song.detectedLanguage ?? "EN")&tl=\(appBrain.user.nativeLanguage.language)&text=\(lyricsViewHandler.cleanWord(word).lowercased())&op=translate")
                lyricsViewHandler.urlString = "https://translate.google.com/?sl=\(songContext.song.detectedLanguage ?? "EN")&tl=\(appBrain.user.nativeLanguage.language)&text=\(lyricsViewHandler.cleanWord(word).lowercased())&op=translate"
                lyricsViewHandler.isWebViewShown.toggle()
            } label: {
                Text("Google Translate")
            }
            
            ForEach(0..<STATIC.languages.count, id: \.self) { i in
                if STATIC.languages[i].language == songContext.song.detectedLanguage ?? "EN"{
                    Button {
                        lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                        print( self.appBrain.getLanguageName(songContext.song.detectedLanguage ?? "EN") ?? "")
                        lyricsViewHandler.urlString = "https://conjugator.reverso.net/conjugation-\(appBrain.getLanguageName(songContext.song.detectedLanguage ?? "EN")?.lowercased() ?? "english")-verb-\(lyricsViewHandler.cleanWord(word)).html"
                        lyricsViewHandler.isWebViewShown.toggle()
           
                    } label: {
                        Text("Show Conjugation (only on Verbs)")
                    }
                }
            }
            /*
                Button {
                    lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                    print( self.appBrain.getLanguageName(self.appBrain.lyricsModel.detectedLanguage.language) ?? "")
                    lyricsViewHandler.urlString = "https://conjugator.reverso.net/conjugation-\(appBrain.getLanguageName(appBrain.lyricsModel.detectedLanguage.language)?.lowercased() ?? "english")-verb-\(lyricsViewHandler.cleanWord(word)).html"
                    lyricsViewHandler.isWebViewShown.toggle()
       
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
