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
