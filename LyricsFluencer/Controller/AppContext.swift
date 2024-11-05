//
//  AppContext.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AppContext: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var path: NavigationPath = NavigationPath()

    func getLanguageName(_ languageCode: String) -> String?{
        for language in STATIC.languages {
            if language.language == languageCode {
                return language.name
            }
        }
        return nil
    }
    
    static func parseData<T: Decodable>(data: Data, dataModel: T.Type, errorAction: (() -> Void)? = nil) -> T?{ //I am parsing data with the dataModel that defines the structure of the data
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            if let errorAction = errorAction{
                errorAction()
            }
            return nil
        }
    }
}
