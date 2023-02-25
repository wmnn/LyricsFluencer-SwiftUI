//
//  HomeViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import FirebaseFirestore

class HomeViewHandler: ObservableObject{
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @Published var isShazamLoading = false
    @Published var isQuickSearchLoading = false
    @Published var searchQuery: String = ""
    
    func handleQuickSearch(searchQuery: String, target: String, appBrain: AppBrain) {
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
                            appBrain.lyricsModel.lyrics = lyricsApiData.lyrics
                            appBrain.lyricsModel.artist = lyricsApiData.artist
                            appBrain.lyricsModel.song = lyricsApiData.song
                            
                            let isCombinedLyrics = await self.handleCombineLyrics(lyricsApiData, appBrain: appBrain)
                            if isCombinedLyrics{
                                print("inside is combined lyrics")
                                appBrain.updateRequestCounter()
                                DispatchQueue.main.async {
                                    self.isQuickSearchLoading = false
                                    appBrain.path.append("Lyrics")
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
    func handleCombineLyrics(_ lyricsApiData: LyricsApiData, appBrain: AppBrain) async -> Bool{
        appBrain.lyricsModel.combinedLyrics = []
        if let translatedLyrics = lyricsApiData.translatedLyrics{
            if let lyrics = appBrain.lyricsModel.lyrics{
                let lyricsArr = lyrics.components(separatedBy: "\n")
                let translatedLyricsArr = translatedLyrics.components(separatedBy: "\n")
                DispatchQueue.main.async {
                    for i in 0..<max(lyricsArr.count, translatedLyricsArr.count) {
                        if i < lyricsArr.count {
                            appBrain.lyricsModel.combinedLyrics?.append(lyricsArr[i])
                        }
                        if i < translatedLyricsArr.count {
                            appBrain.lyricsModel.combinedLyrics?.append(translatedLyricsArr[i])
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
    func handleShazam(){
        
    }
}
