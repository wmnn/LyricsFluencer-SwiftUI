//
//  SongContext.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import Foundation;
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SongContext: ObservableObject {
    
    @Published var song = Song()
    @Published var songApiModel = SongApiModel()
    @Published var songResults: [Song] = []
    @Published var popularSongs: [Song] = []
    
    func updatePopularSongs(){
        songApiModel.updatePopularSongs{ songs, error in
            
            guard error == nil && songs != nil else {
                print("updatePopularSongs Error")
                return;
            }
            
            
            DispatchQueue.main.async{
                self.popularSongs = songs!;
            }
        }
        
    }
    
    func handleManualSearch(searchQuery: String, completion: @escaping ([Song]?, Error?) -> Void) {
        songApiModel.handleManualSearch(searchQuery: searchQuery) { songs, error in
            
            guard error == nil && songs != nil else {
                print("handleManualSearch Error, song context")
                completion(nil, error)
                return;
            }
            
            DispatchQueue.main.async {
                self.songResults = songs!;
                completion(songs, nil)
            }
        }
    }

    func handleSelectedSong(song: Song, nativeLanguage: String, completion: @escaping (SelectedSongResponse) -> Void) {
        songApiModel.handleSelectedSong(song: song, nativeLanguage: nativeLanguage) { res in
            DispatchQueue.main.async {
                self.song = res.song
                completion(res)
            }
        }
    }
    
    func handleQuickSearch(searchQuery: String, targetLanguageCode: String, completion: @escaping (Song?, Error?) -> Void) {
        
        print("Calling in SongContext handleQuickSearch on ApiModel")
        songApiModel.handleQuickSearch(searchQuery: searchQuery, target: targetLanguageCode){ song, error in
            
            guard error == nil && song != nil else {
                print("QuickSearch Error")
                completion(nil, error)
                return;
            }
            
            
            DispatchQueue.main.async{
                self.song = song!;
            }
            completion(song!, nil);
                
        }
    }
}
