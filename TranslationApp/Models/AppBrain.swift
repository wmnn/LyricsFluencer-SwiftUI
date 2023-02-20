//
//  ApiManager.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AppBrain: ObservableObject{
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @Published var isShazamLoading = false
    @Published var targetLanguage = LanguageModel(language: "None", name: "Undefined")
    @Published var isQuickSearchLoading = false
    @Published var lyricsModel = LyricsModel()
    @Published var isTrialExpired = false
    @Published var searchQuery: String = ""
    @Published var isLoggedOut = false
    @Published var isLyrics = false
    
    func handleShazam(){
        
    }
    func handleQuickSearch(searchQuery: String, target: String) {
        self.isQuickSearchLoading = true
        let json: [String: String] = ["searchQuery": searchQuery, "target": target]
        let urlString = "\(STATIC.API_ROOT)/api/quicksearch"
        
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let err = error {
                    print("Error while sending request: \(err)")
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Error while receiving response")
                    return
                }
                print("Success: \(data)")
                if let lyricsApiData: LyricsApiData = self.parseJSON(data){
                    DispatchQueue.main.async {
                        Task {
                            self.lyricsModel.lyrics = lyricsApiData.lyrics
                            self.lyricsModel.artist = lyricsApiData.artist
                            self.lyricsModel.song = lyricsApiData.song
                            
                            let isCombinedLyrics = await self.handleCombineLyrics(lyricsApiData)
                            if isCombinedLyrics{
                                print("inside is combined lyrics")
                                self.updateRequestCounter()
                                self.isQuickSearchLoading = false
                                DispatchQueue.main.async {
                                    self.isLyrics = true
                                }
                            }else{
                                
                            }
                        }
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    func handleCombineLyrics(_ lyricsApiData: LyricsApiData) async -> Bool{
        
            if let translatedLyrics = lyricsApiData.translatedLyrics{
                if let lyrics = self.lyricsModel.lyrics{
                    let lyricsArr = lyrics.components(separatedBy: "\n")
                    let translatedLyricsArr = translatedLyrics.components(separatedBy: "\n")
                    DispatchQueue.main.async {
                        for i in 0..<max(lyricsArr.count, translatedLyricsArr.count) {
                            if i < lyricsArr.count {
                                self.lyricsModel.combinedLyrics?.append(lyricsArr[i])
                            }
                            if i < translatedLyricsArr.count {
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
    func parseJSON(_ lyricsData: Data) -> LyricsApiData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(LyricsApiData.self, from: lyricsData)
            return decodedData
        }catch {
            print(error)
            return nil
        }
    }
    func updateRequestCounter(){
        let uid = getCurrentUser()
        let userRef = db.collection("users").document(uid)
        userRef.updateData(["requests": FieldValue.increment(Int64(1))]) { (error) in
            if error == nil {
                    print("Updated request counter")
            }else{
                    print("not updated")
            }
        }
        if let requests = defaults.string(forKey: "requests"){
            defaults.set((Int(requests) ?? 99) + 1 , forKey: "requests")
            DispatchQueue.main.async {
                self.handleTrial()
            }
        }
    }
    func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    func logout(){
        defaults.set("", forKey: "uid") //Item like array
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            handleDeleteLocalStorage()
            self.isLoggedOut.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func handleDeleteLocalStorage(){
        UserDefaults.standard.removeObject(forKey: "subscriptionPlan")
        UserDefaults.standard.removeObject(forKey: "defaultLanguage")
        UserDefaults.standard.removeObject(forKey: "defaultLanguageName")
        UserDefaults.standard.removeObject(forKey: "requests")
    }
    
    func handleTrial(){
        if let subscriptionPlan = defaults.string(forKey: "subscriptionPlan"){
            if subscriptionPlan == "free" {
                if let requests = defaults.string(forKey: "requests"){
                    if Int(requests) ?? 99 > 20 {
                        self.isTrialExpired = true
                        print("isTrialExpired? \(String(isTrialExpired))")
                    }
                }
            }
        }
    }

}
