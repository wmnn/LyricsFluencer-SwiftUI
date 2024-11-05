//
//  LyricsViewController.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation

class LyricsViewController: ObservableObject{
    @Published var isWebViewShown = false
    @Published var isAddToDeckViewShown = false
    @Published var selectedWord: String = ""
    //For the WebView
    @Published var urlString: String = "https://www.google.com"
    //For creating a new card
    @Published var front: String = ""
    @Published var back: String = ""
    @Published var showCreateDeckAlert = false
    @Published var createDeckName = ""
    
    func handleSplittingLine(line:String) -> [String]{
        let separator = CharacterSet(charactersIn: " \n")
        let words = line.components(separatedBy: separator).map { word -> String in
            if word.hasSuffix("\n") {
                return String(word.dropLast()) + "\n"
            } else {
                return word
            }
        }
        return words
    }
    func cleanWord(_ word: String) -> String {
        var newWord = word
        if word.hasSuffix(",") || word.hasSuffix("'") {
            newWord = String(word.dropLast())
        }
        return newWord
    }
}
