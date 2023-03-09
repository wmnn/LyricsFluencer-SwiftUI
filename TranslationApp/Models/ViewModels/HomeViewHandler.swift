//
//  HomeViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import FirebaseFirestore
import ShazamKit
import AVKit //for using the microphone

class HomeViewHandler: NSObject, ObservableObject{ //NSObject because the need it to,  conform to shazams delegates
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var appBrain: AppBrain?
    @Published var isShazamLoading = false
    @Published var isQuickSearchLoading = false
    @Published var searchQuery: String = ""
    //For Shazam
    @Published var shazamMedia = ShazamMedia(
        title: "Title ...",
        subtitle: "Subtitle ...",
        artistName: "Artist ...",
        albumArtURL: URL(string: "https://google.com"),
        genres: ["Pop"])
    @Published var isRecording = false
    private let audioEngine = AVAudioEngine() //To get microphone input
    private let session = SHSession() //Shazam request
    private let signatureGenerator = SHSignatureGenerator() //Shazam only accepts shsignature files
    override init(){
        super.init()
        session.delegate = self
    }

    func handleQuickSearch(searchQuery: String, target: String) {
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
                            self.appBrain!.lyricsModel.lyrics = lyricsApiData.lyrics
                            print(lyricsApiData.lyrics)
                            self.appBrain!.lyricsModel.artist = lyricsApiData.artist
                            self.appBrain!.lyricsModel.song = lyricsApiData.song
                            print(self.appBrain!.lyricsModel.song!)
                            let isCombinedLyrics = await self.handleCombineLyrics(lyricsApiData)
                            if isCombinedLyrics{
                                print(self.appBrain!.lyricsModel.combinedLyrics!)
                                print("inside is combined lyrics")
                                //appBrain.updateRequestCounter()
                                DispatchQueue.main.async {
                                    if self.isShazamLoading {
                                        self.isShazamLoading = false
                                    }
                                    if self.isQuickSearchLoading{
                                        self.isQuickSearchLoading = false
                                    }
                                
                                    self.appBrain!.path.append("Lyrics")
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    func handleCombineLyrics(_ lyricsApiData: LyricsApiData) async -> Bool{
        DispatchQueue.main.async {
            self.appBrain!.lyricsModel.combinedLyrics = []
        }
            if let translatedLyrics = lyricsApiData.translatedLyrics{
                if let lyrics = self.appBrain!.lyricsModel.lyrics{
                    let lyricsArr = lyrics.components(separatedBy: "\n")
                    let translatedLyricsArr = translatedLyrics.components(separatedBy: "\n")
                        for i in 0..<max(lyricsArr.count, translatedLyricsArr.count) {
                            if i < lyricsArr.count {
                                DispatchQueue.main.async {
                                    self.appBrain!.lyricsModel.combinedLyrics?.append(lyricsArr[i])
                                }
                            }
                            if i < translatedLyricsArr.count {
                                DispatchQueue.main.async {
                                    self.appBrain!.lyricsModel.combinedLyrics?.append(translatedLyricsArr[i])
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
        self.startOrEndListening()
    }
    public func startOrEndListening(){
        guard !audioEngine.isRunning else{
            audioEngine.stop()
            DispatchQueue.main.async {
                self.isRecording = false
            }
            return
        }
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.requestRecordPermission { granted in
            guard granted else { return }
            try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = self.audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
                (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.session.matchStreamingBuffer(buffer, at: nil)
                
            }
            self.audioEngine.prepare()
            do {
                try self.audioEngine.start()
            } catch (let error){
                assertionFailure(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isRecording = true
            }
        }
    }
}

struct ShazamMedia: Decodable{
    let title: String?
    let subtitle: String?
    let artistName: String?
    let albumArtURL: URL?
    let genres: [String]
}

//For Shazam

extension HomeViewHandler: SHSessionDelegate{
    //SHSessionDelegate in order to use the second shazam function, you could add SHSessionDelegate to the HomeViewHandler but that wouldn't be that clean
    func session(_ session: SHSession, didFind match: SHMatch) {
        let mediaItems = match.mediaItems
        if let firstItem = mediaItems.first{ //it can contain multiple, therefore only the first item
            let _shazamMedia = ShazamMedia(title: firstItem.title, subtitle: firstItem.subtitle, artistName: firstItem.artist, albumArtURL: firstItem.artworkURL, genres: firstItem.genres)
            DispatchQueue.main.async {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.shazamMedia = _shazamMedia
                self.appBrain?.lyricsModel.albumArtURL = firstItem.artworkURL
                self.handleQuickSearch(searchQuery: (firstItem.title ?? "") + " " + (firstItem.artist ?? ""), target: self.appBrain!.user.targetLanguage.language)
            }
        }
    }
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error{
            print(error)
        }
    }
}
