//
//  BrowseViewController.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 07.04.23.
//

import Foundation

class BrowseViewController: ObservableObject{
    @Published var isShowSearchResultsLoading : Bool = false
    @Published var searchQuery : String = ""
    @Published var popularSongs: [PopularSongApiDataContainer] = []
    @Published var searchResults: [PopularSongApiDataContainer] = []
    var appBrain: AppBrain?
    
    func fetchPopularSongs(){
        let json: [String: String] = ["learnedLanguage": appBrain!.user.learnedLanguage.language]
        let urlString = "\(STATIC.API_ROOT)/api/songs/popular"
        
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
                //Successfull Request
                
                if let popularSongsApiData: PopularSongsApiData = AppBrain.parseData(data: data, dataModel: PopularSongsApiData.self){
                    DispatchQueue.main.async {
                        Task {
                            for i in 0..<popularSongsApiData.data.count {
                                print(i)
                                print(popularSongsApiData.data[i])
                                self.popularSongs.append(popularSongsApiData.data[i])
                            }
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    func handleSearch(){
        self.isShowSearchResultsLoading = true
        self.searchResults = []
        let json: [String: String] = ["searchQuery": self.searchQuery]
        let urlString = "\(STATIC.API_ROOT)/api/songs/search"
        
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let err = error {
                    print("Error while sending request: \(err)")
                    self.isShowSearchResultsLoading = false
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Error while receiving response")
                    self.isShowSearchResultsLoading = false
                    return
                }
                //Successfull Request
                
                if let searchedSongsApiData: PopularSongsApiData = AppBrain.parseData(data: data, dataModel: PopularSongsApiData.self){
                    DispatchQueue.main.async {
                        Task {
                            for i in 0..<searchedSongsApiData.data.count {
                                print(i)
                                print(searchedSongsApiData.data[i])
                                self.searchResults.append(searchedSongsApiData.data[i])
                            }
                            self.isShowSearchResultsLoading = false
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func handleSelectedSong(commontrack_id : Int){
        let json: [String: String] = ["commontrack_id": String(commontrack_id), "targetLanguage" : appBrain!.user.nativeLanguage.language]
        let urlString = "\(STATIC.API_ROOT)/api/songs/lyrics"
        
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
                    //Successfull Request
                    if let selectedSongApiData: SelectedSongApiData = AppBrain.parseData(data: data, dataModel: SelectedSongApiData.self){
                        DispatchQueue.main.async {
                            Task {
                                self.appBrain?.lyricsModel.lyrics = selectedSongApiData.lyrics
                                self.appBrain?.lyricsModel.detectedLanguage.language = selectedSongApiData.detectedLanguage ?? ""
                                let success = await self.appBrain!.handleCombineLyrics(selectedSongApiData, dataModel: SelectedSongApiData.self)
                                if success {
                                    self.appBrain!.path.append("Lyrics")
                                }else {
                                    
                                }
                            }
                        }
                    }
                }
                task.resume()
            }
        
        
        
    }
}
