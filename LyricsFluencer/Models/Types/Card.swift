//
//  Card.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import Foundation
import FirebaseFirestore

struct Card: Hashable, Identifiable, Codable{
    var front: String
    var back: String
    // var createdAt: Date?
    var interval: Int = 0
    var due: Date
    var id: String
    
    private enum CodingKeys: String, CodingKey {
        case front, back, interval, due, id
    }

    init(front: String, back: String, interval: Int, due: Date, id: String) {
        self.front = front
        self.back = back
        self.interval = interval
        self.due = due
        self.id = id
    }
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
        front = try! container.decode(String.self, forKey: .front)
        back = try! container.decode(String.self, forKey: .back)
        interval = try! container.decode(Int.self, forKey: .interval)
        
        // Decode `due` (handle Timestamp, String, or Integer cases)
        if let timestamp = try? container.decode(FirebaseFirestore.Timestamp.self, forKey: .due) {
            due = timestamp.dateValue()  // Convert Timestamp to Date
        } else if let dueString = try? container.decode(String.self, forKey: .due) {
            // If the `due` is a String (ISO 8601 format)
            if let date = ISO8601DateFormatter().date(from: dueString) {
                due = date
            } else {
                // Fallback if parsing fails
                due = Date() // Or handle error accordingly
            }
        } else if let dueInt = try? container.decode(Int.self, forKey: .due) {
            // If `due` is an Integer (timestamp in seconds since epoch)
            due = Date(timeIntervalSince1970: TimeInterval(dueInt))
        } else {
            // Fallback case, if nothing matches
            due = Date()  // Set a default value if nothing is decoded
        }
    }
    
    
}
