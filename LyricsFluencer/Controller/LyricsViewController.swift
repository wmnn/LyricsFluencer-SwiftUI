//
//  LyricsViewController.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation

class LyricsViewController: ObservableObject{
    
    // Environment Objects
    var userContext: UserContext?
    var songContext: SongContext?
    
    @Published var selectedWord: String = ""
    //For the WebView
    @Published var isWebViewShown = false
    @Published var urlString: String = "https://www.google.com"
    //For creating a new card
    @Published var isAddToDeckViewShown = false
    @Published var front: String = ""
    @Published var back: String = ""
    @Published var showCreateDeckAlert = false
    @Published var createDeckName = ""
    
    func setSelectedWord(word: String) {
        self.selectedWord = self.cleanWord(word)
    }
    
    func updateAddToDeckValues(_ word: String) {
        self.setSelectedWord(word: word)
        self.front = ""
        self.back = self.cleanWord(word)
        self.urlString = """
        https://www.google.com/search?q=\(selectedWord)+\(
            (LanguageUtil.getLanguageName(songContext!.song.language ?? "") ?? "").lowercased()
        )+meaning
        """
        self.isAddToDeckViewShown.toggle()
    }
    
    func updateGoogleTranslateValues(_ word: String) {
        setSelectedWord(word: word)
        urlString = """
        https://translate.google.com/?sl=\(songContext!.song.language ?? "EN")&tl=\(userContext!.user!.nativeLanguage ?? "DE")&text=\(selectedWord.lowercased())&op=translate
        """
        isWebViewShown.toggle()
    }
    
    func cleanWord(_ word: String) -> String {
        var newWord = word
        if word.hasSuffix(",") || word.hasSuffix("'") {
            newWord = String(word.dropLast())
        }
        return newWord
    }
}
