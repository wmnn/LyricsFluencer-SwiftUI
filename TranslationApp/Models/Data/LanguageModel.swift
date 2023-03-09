//
//  LanguageModel.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI

struct LanguageModel: Codable{
    var language: String = "None"
    var id: String {
        language
    }
}
