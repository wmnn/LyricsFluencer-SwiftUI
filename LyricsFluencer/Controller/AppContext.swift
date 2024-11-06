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

enum Views: String {
    case Login = "Login"
    case Home = "Home"
    case Lyrics = "Lyrics"
    case Flashcards = "Flashcards"
    case DeckSettingsView = "DeckSettingsView"
    case CardsView = "CardsView"
    case EditCardsView = "EditCardsView"
    case Settings = "Settings"
    case Browse = "Browse"
    case Register = "Register"
    
}

class AppContext: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var path: NavigationPath = NavigationPath()
    
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
    
    // Method to navigate to a specific view using the Views enum
    func navigate(to view: Views) {
        print(path)
        path.append(view.rawValue)
    }
    func resetNavigationPath() {
        self.path = NavigationPath()
    }
}
