//
//  LyricsModel.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import Foundation

struct Lyrics: Codable{
    var artist: String?
    var song: String?
    var lyrics: String?
    var detectedLanguage: Language = Language(language: "")
    var combinedLyrics: [String]? = []
    var albumArtURL: URL?
}
