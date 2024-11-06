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
                lyricsViewController.selectedWord = lyricsViewController.cleanWord(word)
                lyricsViewController.front = ""
                lyricsViewController.back = lyricsViewController.cleanWord(word)
                lyricsViewController.urlString = "https://www.google.com/search?q=\(lyricsViewController.cleanWord(word))+\(LanguageUtil.getLanguageName(songContext.song.detectedLanguage ?? "EN")?.lowercased() ?? "show")+meaning"
                lyricsViewController.isAddToDeckViewShown.toggle()
            } label: {
                Text("Add to deck")
            }
            Button {
                lyricsViewController.selectedWord = lyricsViewController.cleanWord(word)
                lyricsViewController.urlString = "https://www.google.com/search?q=\(lyricsViewController.cleanWord(word))+\(LanguageUtil.getLanguageName(songContext.song.detectedLanguage ?? "EN")?.lowercased() ?? "show")+meaning"
                lyricsViewController.isWebViewShown.toggle()
            } label: {
                Text("Google Meaning")
            }
            
            Button {
                lyricsViewController.selectedWord = lyricsViewController.cleanWord(word)
                print("https://translate.google.com/?sl=\(songContext.song.detectedLanguage ?? "EN")&tl=\(userContext.user!.nativeLanguage ?? "DE")&text=\(lyricsViewController.cleanWord(word).lowercased())&op=translate")
                lyricsViewController.urlString = "https://translate.google.com/?sl=\(songContext.song.detectedLanguage ?? "EN")&tl=\(userContext.user!.nativeLanguage ?? "DE")&text=\(lyricsViewController.cleanWord(word).lowercased())&op=translate"
                lyricsViewController.isWebViewShown.toggle()
            } label: {
                Text("Google Translate")
            }
            
            /*
            ForEach(0..<STATIC.languages.count, id: \.self) { i in
                if STATIC.languages[i].language == songContext.song.detectedLanguage ?? "EN"{
                    Button {
                        lyricsViewController.selectedWord = lyricsViewController.cleanWord(word)
                        print( self.appBrain.getLanguageName(songContext.song.detectedLanguage ?? "EN") ?? "")
                        lyricsViewController.urlString = "https://conjugator.reverso.net/conjugation-\(appBrain.getLanguageName(songContext.song.detectedLanguage ?? "EN")?.lowercased() ?? "english")-verb-\(lyricsViewController.cleanWord(word)).html"
                        lyricsViewController.isWebViewShown.toggle()
           
                    } label: {
                        Text("Show Conjugation (only on Verbs)")
                    }
                }
            }*/
            /*
                Button {
                    lyricsViewController.selectedWord = lyricsViewController.cleanWord(word)
                    print( self.appBrain.getLanguageName(self.appBrain.lyricsModel.detectedLanguage.language) ?? "")
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
