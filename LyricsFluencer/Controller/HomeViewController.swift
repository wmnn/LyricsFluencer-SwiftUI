//
//  HomeViewController.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import Firebase
import FirebaseFirestore
import ShazamKit
import AVKit //for using the microphone

class HomeViewController: NSObject, ObservableObject { //NSObject because the need it to,  conform to shazams delegates
    
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var appBrain: AppContext?
    var songContext: SongContext?
    var userContext: UserContext?
    
    @Published var isQuickSearchLoading = false
    @Published var searchQuery: String = ""
    @Published var isErrorModalShown = false;
    @Published var errorMessage = "";
    //For Shazam
    @Published var isShazamLoading = false
    @Published var isRecording = false
    @Published var shazamMedia = ShazamMedia(
        title: "Title ...",
        subtitle: "Subtitle ...",
        artistName: "Artist ...",
        albumArtURL: URL(string: "https://google.com"),
        genres: ["Pop"])
    private let audioEngine = AVAudioEngine() //To get microphone input
    private let session = SHSession() //Shazam request
    private let signatureGenerator = SHSignatureGenerator() //Shazam only accepts shsignature files
    override init(){
        super.init()
        session.delegate = self
    }
    
    func handleQuickSearch() {
        
        guard isQuickSearchLoading == false else {
            DispatchQueue.main.async {
                self.isQuickSearchLoading = false
                self.isShazamLoading = false
            }
            return;
        }
        guard isShazamLoading == false else {
            
            return;
        }
        
        self.isQuickSearchLoading = true
        
        songContext?.handleQuickSearch(searchQuery: searchQuery, targetLanguageCode: userContext!.user!.learnedLanguage ?? "DE"){ song, error in
            
            guard song != nil && error == nil else {
                DispatchQueue.main.async {
                    self.isQuickSearchLoading = false;
                    self.isErrorModalShown = true;
                    self.errorMessage = "An error occured.";
                }
                return;
            }
            
            DispatchQueue.main.async {
                if (!self.isShazamLoading && !self.isQuickSearchLoading) || (self.isShazamLoading && self.isQuickSearchLoading) {
                    
                    self.isShazamLoading = false
                    self.isQuickSearchLoading = false
                    return
                    
                } else {
                    
                    if self.isQuickSearchLoading{
                        self.isQuickSearchLoading = false
                    }
                    
                    if self.isShazamLoading {
                        self.isRecording = false
                        self.isShazamLoading = false
                    }
                    
                    self.appBrain!.navigate(to: Views.Lyrics)
                }
            }
        }
    }
    
    func turnOffActivityIndicator(){
        DispatchQueue.main.async {
            self.isQuickSearchLoading = false
            self.isRecording = false
            self.isShazamLoading = false
        }
    }

    func handleShazam(){
        
        guard isQuickSearchLoading == false else {
            return;
        }
      
        self.isShazamLoading = true
        self.startOrEndListening()
    
    }
    
    public func startOrEndListening() {
        
        if isRecording {
            self.isRecording = false
            self.isShazamLoading = false
        }
        
        guard !audioEngine.isRunning else {
            // Remove the tap from the input node
            let inputNode = audioEngine.inputNode
            inputNode.removeTap(onBus: 0)
            // Stop the audio engine
            audioEngine.stop()
            
            // Update the UI
            DispatchQueue.main.async {
                self.isRecording = false
                self.isShazamLoading = false
            }
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.requestRecordPermission { granted in
            
            guard granted else {
                print("Not granted")
                self.isShazamLoading = false
                return
            }
            
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

extension HomeViewController: SHSessionDelegate{
    //SHSessionDelegate in order to use the second shazam function, you could add SHSessionDelegate to the HomeViewHandler but that wouldn't be that clean
    func session(_ session: SHSession, didFind match: SHMatch) {
        guard isRecording == true && isShazamLoading == true else {
            return;
        }
      
        let mediaItems = match.mediaItems
        if let firstItem = mediaItems.first { //it can contain multiple, therefore only the first item
            
            let _shazamMedia = ShazamMedia(title: firstItem.title, subtitle: firstItem.subtitle, artistName: firstItem.artist, albumArtURL: firstItem.artworkURL, genres: firstItem.genres)
            
            DispatchQueue.main.async {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.shazamMedia = _shazamMedia
         
                self.searchQuery = (firstItem.title ?? "") + " " + (firstItem.artist ?? "")
                self.handleQuickSearch()
            }
        }
        
    }
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error{
            print(error)
            DispatchQueue.main.async {
                self.isRecording = false
                self.isShazamLoading = false
            }
            
        }
    }
}
