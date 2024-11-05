//
//  Constants.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 20.02.23.
//

import Foundation

struct STATIC{
    //static let API_ROOT = "https://www.lyricsfluencer.com"
    static let API_ROOT = "http://localhost:3000"
    static let languages: [Language] = [
        Language(language: "ar", name: "Arabic"),
        Language(language: "en", name: "English"),
        Language(language: "fr", name: "French"),
        Language(language: "de", name: "German"),
        Language(language: "it", name: "Italian"),
        Language(language: "ja", name: "Japanese"),
        Language(language: "pt", name: "Portuguese"),
        Language(language: "ru", name: "Russian"),
        Language(language: "es", name: "Spanish"),
        Language(language: "tr", name: "Turkish"),
    ]
}
