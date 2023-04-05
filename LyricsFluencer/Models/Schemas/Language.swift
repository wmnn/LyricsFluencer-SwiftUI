//
//  LanguageModel.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI

struct Language: Codable, Identifiable{
    var language: String = "None"
    var name: String?
    var id: String {
        language
    }
}
