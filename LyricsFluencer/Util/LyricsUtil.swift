//
//  LyricsUtil.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 06.11.24.
//
import Foundation

class LyricsUtil {
    
    static func getWordsFromString(line:String) -> [String] {
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
}
