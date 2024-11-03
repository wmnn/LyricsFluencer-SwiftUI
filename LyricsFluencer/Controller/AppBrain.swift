//
//  ApiManager.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AppBrain: ObservableObject{
    let db = Firestore.firestore()
    @Published var path: NavigationPath = NavigationPath()
    @Published var user = User()
    @Published var lyricsModel = Lyrics()
    @Published var deckModel: DeckModel = DeckModel()

    func handleTrial(){
        let subscriptionPlan = LocaleStorage.getValue(for: "subscriptionPlan")
        let subscriptionStatus = LocaleStorage.getValue(for: "subscriptionStatus")
      
        if subscriptionPlan == "free" || subscriptionStatus == "EXPIRED" {
            let requests = LocaleStorage.getValue(for: "requests")
            if Int(requests ?? "") ?? 99 > 5 {
                self.user.isTrialExpired = true
            }else{
                self.user.isTrialExpired = false
            }
        }else{
            self.user.isTrialExpired = false
        }
    }

    func getLanguageName(_ languageCode: String) -> String?{
        for language in STATIC.languages {
            if language.language == languageCode {
                return language.name
            }
        }
        return nil
    }
    
    func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            LocaleStorage.removeData()
            self.user.isSubscriptionPlanChecked = false
            self.user = User()
            self.path = NavigationPath()
        } catch let signOutError as NSError {
            LocaleStorage.removeData()
            self.user.isSubscriptionPlanChecked = false
            self.path = NavigationPath()
            print("Error signing out: %@", signOutError)
        }
    }
    
    func updateRequestCounter(){
        let uid = FirebaseModel.getCurrentUser()
        let userRef = db.collection("users").document(uid)
        userRef.updateData(["requests": FieldValue.increment(Int64(1))]) { (error) in
            if error == nil {
                print("Updated request counter")
            }else{
                print("not updated")
            }
        }
        if let requests = LocaleStorage.getValue(for: "requests"){
            LocaleStorage.setValue(for: "requests", value: (Int(requests)! + 1))
            self.user.requests = Int(requests)! + 1
            DispatchQueue.main.async {
                self.handleTrial()
            }
        }
    }

    func handleAddToDeck(front: String, back: String) -> String{
        return deckModel.handleAddToDeck(front: front, back: back)
    }
    
    func createDeck(deckName: String){
        deckModel.createDeck(deckName: deckName)
    }
    
    func fetchingDecks() {
        deckModel.fetchingDecks()
    }
    
    func checkSubscriptionPlan(){
        if !self.user.isSubscriptionPlanChecked{
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    // Handle error
                    print(error)
                    return;
                }
                let urlString = "\(STATIC.API_ROOT)/payment/plan?token=\(idToken ?? "")"
                if let url = URL(string: urlString){
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let err = error {
                            print("Error while sending request: \(err)")
                            return
                        }
                        
                        guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                            print("Error while receiving response")
                            return
                        }
                        //print("Success: \(data)")
                        if let planApiData: PlanApiData = AppBrain.parseData(data: data, dataModel: PlanApiData.self){
                            DispatchQueue.main.async {
                                Task {
                                    //print(planApiData)
                                    self.user.isSubscriptionPlanChecked = true
                                    LocaleStorage.setValue(for: "subscriptionPlan", value: planApiData.subscriptionPlan)
                                    LocaleStorage.setValue(for: "subscriptionStatus", value: planApiData.subscriptionStatus ?? "")
                                    self.handleTrial()
                                }
                            }
                        }
                    }
                    task.resume()
                }
                
            }
        }
        
        
    }
    static func parseData<T: Decodable>(data: Data, dataModel: T.Type, errorAction: (() -> Void)? = nil) -> T?{ //I am parsing data with the dataModel that defines the structure of the data
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        }catch {
            print(error)
            if let errorAction = errorAction{
                errorAction()
            }
            return nil
        }
    }
    
    func handleCombineLyrics<T: CombinedLyricsDataProtocol>(_ data: T, dataModel: T.Type) async -> Bool{
        DispatchQueue.main.async {
            self.lyricsModel.combinedLyrics = []
        }
        if let translatedLyrics = data.translatedLyrics{
            if let lyrics = self.lyricsModel.lyrics{
                let lyricsArr = lyrics.components(separatedBy: "\n")
                let translatedLyricsArr = translatedLyrics.components(separatedBy: "\n")
                for i in 0..<max(lyricsArr.count, translatedLyricsArr.count) {
                    if i < lyricsArr.count {
                        DispatchQueue.main.async {
                            self.lyricsModel.combinedLyrics?.append(lyricsArr[i])
                        }
                    }
                    if i < translatedLyricsArr.count {
                        DispatchQueue.main.async {
                            self.lyricsModel.combinedLyrics?.append(translatedLyricsArr[i])
                        }
                    }
                }
            }else{
                return false
            }
            return true
        }else{
            return false
        }
    }
}

protocol CombinedLyricsDataProtocol: Decodable {
    var translatedLyrics: String? { get }
}
