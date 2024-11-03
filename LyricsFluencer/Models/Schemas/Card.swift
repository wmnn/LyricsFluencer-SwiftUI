//
//  Card.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import Foundation

struct Card: Hashable, Identifiable, Codable{
    var front: String
    var back: String
    var createdAt: Date?
    var interval: Int = 0
    var due: Date
    var id: String
}
