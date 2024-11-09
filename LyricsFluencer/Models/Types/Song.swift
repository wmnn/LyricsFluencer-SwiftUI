//
//  LyricsModel.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import Foundation

struct Song: Codable {
    
    var id: String?
    var artist: String?
    var name: String?
    var lyrics: [String]?
    var translation: [String]?
    var language: String?
    var url: String?
    var album: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, artist, name, lyrics, translation, language, url, album
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle `id` as either Int or String
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch {
            // Try to decode as Int and convert to String if it fails
            id = String(try container.decode(Int.self, forKey: .id))
        }
        
        // Decode other properties as optional Strings
        artist = try? container.decode(String.self, forKey: .artist)
        name = try? container.decode(String.self, forKey: .name)
        lyrics = try? container.decode([String].self, forKey: .lyrics)
        translation = try? container.decode([String].self, forKey: .translation)
        language = try? container.decode(String.self, forKey: .language)
        url = try? container.decode(String.self, forKey: .url)
        album = try? container.decode(String.self, forKey: .album)
    }
}
