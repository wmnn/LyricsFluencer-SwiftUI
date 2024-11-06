//
//  LanguageUtil.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 06.11.24.
//
class LanguageUtil {
    
    static func getLanguageName(_ languageCode: String) -> String? {
     
        for language in STATIC.languages {
            if language.language == languageCode {
                return language.name
            }
        }
        return nil
    
    }
}
