//
//  LyricsModel.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import Foundation

struct LyricsApiData: Codable {
    let status: Int
    let artist: String
    let song: String
    let lyrics: String
    let translatedLyrics: String?
    let detectedLanguage: String?
}
