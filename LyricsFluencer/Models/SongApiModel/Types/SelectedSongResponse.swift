//
//  SelectedSongResponse.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import Foundation

struct SelectedSongResponse: Codable {
    let song: Song
    let status: Int
    // let detectedLanguage: String?
}

