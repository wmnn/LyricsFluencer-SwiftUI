//
//  LyricsModel.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import Foundation

struct LyricsModel: Codable{
    var artist: String?
    var song: String?
    var lyrics: String?
    var combinedLyrics: [String]? = []
    var albumArtURL: URL?
}
