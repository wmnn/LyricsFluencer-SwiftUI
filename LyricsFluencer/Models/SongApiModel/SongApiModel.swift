//
//  SongApiModel.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import Foundation

class SongApiModel {
    
    func handleManualSearch(searchQuery: String, completion: @escaping ([Song]?, Error?) -> Void) {
        
        let json: [String: String] = ["searchQuery": searchQuery]
        let urlString = "\(STATIC.API_ROOT)/api/search"
        
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let err = error {
                    completion(nil, NSError());
                    print("Error while sending request: \(err)")
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(nil, NSError());
                    print("Error while receiving response")
                    return
                }
                
                //Successfull Request
                if let res: ManualSearchResponse = AppBrain.parseData(data: data, dataModel: ManualSearchResponse.self){
                    completion(res.songs, nil);
                }
            }
            task.resume()
        }
    }
    
    func handleSelectedSong(song: Song, nativeLanguage: String, completion: @escaping (SelectedSongResponse) -> Void) {
        
        print("executing handle selected song in song api model")
        let songJSON = String(data: try! JSONEncoder().encode(song), encoding: .utf8)!
        
        let json: [String: String] = ["song": songJSON, "nativeLanguage" : nativeLanguage]
        let urlString = "\(STATIC.API_ROOT)/api/selected"
        
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let err = error {
                    print("Error while sending request: \(err), handle selected song")
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Error while receiving response, handle selected song")
                    return
                }
                //Successfull Request
                if let res: SelectedSongResponse = AppBrain.parseData(data: data, dataModel: SelectedSongResponse.self) {
                    completion(res)
                }
            }
            task.resume()
        }
        
    }
    func handleQuickSearch(searchQuery: String, target: String, completion: @escaping (Song?, Error?) -> Void) {
        
        print("Doing QuickSearch request")
        let json: [String: String] = ["searchQuery": searchQuery, "target": target]
        let urlString = "\(STATIC.API_ROOT)/api/quicksearch"
    
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(nil, ApiError.QuickSearch)
                    // print("Error while sending request: \(err)")
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Error while receiving response, quick search")
                    completion(nil, ApiError.QuickSearch)
                    return
                }
            
                if let res: QuickSearchResponse = AppBrain.parseData(data: data, dataModel: QuickSearchResponse.self) {
                    completion(res.song, nil)
                }
                
            }
            task.resume()
        }
        
    }

    func updatePopularSongs(completion: @escaping ([Song]?, Error?) -> Void) {
        
        let json: [String: String] = ["targetLanguage": "DE"]
        let urlString = "\(STATIC.API_ROOT)/api/popular"
        
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if error != nil {
                    completion(nil, error)
                    print("Error while sending request: \(error!)")
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(nil, nil)
                    print("Error while receiving response, update popular songs")
                    return
                }
                
                //Successfull Request
                if let res: PopularSongsResponse = AppBrain.parseData(data: data, dataModel: PopularSongsResponse.self) {
                    completion(res.songs, nil)
                }
                
            }
            task.resume()
        }
    }
    
}
