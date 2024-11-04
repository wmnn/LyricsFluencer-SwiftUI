//
//  PopularSongsApiData.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 07.04.23.
//

import Foundation

struct PopularSongsResponse: Codable{
    var status: Int
    var songs : [Song]
}
/*
struct PopularSongApiDataContainer: Codable, Identifiable{
    var id: Int { track.commontrack_id }
    var track: PopularSongApiData
}
struct PopularSongApiData: Codable, Identifiable{
    var id: Int { commontrack_id }
    var track_name: String
    var track_id: Int
    var commontrack_id: Int
    var album_name: String
    var artist_name: String
}
*/
