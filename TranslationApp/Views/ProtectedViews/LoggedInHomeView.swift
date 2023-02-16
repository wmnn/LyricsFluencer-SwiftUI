//
//  LoggedInHomeView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoggedInHomeView: View {
    let db = Firestore.firestore()
    @State private var searchQuery: String = ""
    @State private var isLoggedOut = false
    @State private var isLyrics = false
    @State private var lyrics = ""
    @State private var combinedLyrics: [String] = []
    @State private var lyricsArr: [String] = []
    @State private var artist = ""
    @State private var song = ""
    //@Binding var path: NavigationPath
    @State var targetLanguage = LanguageModel(language: "None", name: "Undefined")
    
    @State private var isShazamLoading = false
    @State private var isQuickSearchLoading = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("appColor")
                    .ignoresSafeArea()
                VStack{
                    Menu{
                        ForEach(0..<Constants.languages.count, id: \.self) { index in
                            Button {
                                self.targetLanguage.language = Constants.languages[index].language
                                self.targetLanguage.name = Constants.languages[index].name
                            } label: {
                                Text(Constants.languages[index].name)
                            }
                        }
                    } label: {
                        Label(
                            title: {Text("Target language: \(targetLanguage.name)")
                                    .font(.system(size:24))
                                    .bold()
                                    .frame(width: 300, height: 20, alignment: .center)
                                    .foregroundColor(Color.black)
                                    .padding()
                                    .background {
                                        Color("primaryColor")
                                    }
                                    .cornerRadius(18)
                            },
                            icon: { Image(systemName: "")}
                        )
                        
                    }
                    
                    
                    Button {
                        //handleShazam()
                        self.isShazamLoading.toggle()
                        updateRequestCounter()
                    } label: {
                        if isShazamLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .font(.system(size:24))
                                .bold()
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color.black)
                                .padding()
                                .background {
                                    Color("primaryColor")
                                }
                                .cornerRadius(18)
                        }else{
                            Label(
                                title: {Text("Recognize Song ")
                                    
                                }
                                , icon: {Image(systemName: "shazam.logo.fill")})
                            .font(.system(size:24))
                            .bold()
                            .frame(width: 300, height: 20, alignment: .center)
                            .foregroundColor(Color.black)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                        }
                    }
                    
                    
                    TextField(text: $searchQuery){
                        Text("Search").foregroundColor(Color.gray)
                    }
                    .font(.system(size:24))
                    .frame(width: 300, height: 20, alignment: .center)
                    .padding()
                    .foregroundColor(Color.black)
                    .background{
                        Color("inputColor")
                    }
                    .cornerRadius(18)
                    
                    
                    Button {
                        self.isQuickSearchLoading = true
                        handleQuickSearch(searchQuery: searchQuery, target: targetLanguage.language)
                    } label: {
                        if isQuickSearchLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .font(.system(size:24))
                                .bold()
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color.black)
                                .padding()
                                .background {
                                    Color("primaryColor")
                                }
                                .cornerRadius(18)
                        } else{
                            HStack{
                                Text("Quick Search")
                                Image(systemName: "magnifyingglass")
                            }
                            .bold()
                            .font(.system(size:24))
                            .frame(width: 300, height: 20, alignment: .center)
                            .foregroundColor(Color.black)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                        }
                    }
                    /*
                    
                    Button {

                    } label: {
                        Text("Flashcards")
                            .bold()
                            .font(.system(size:24))
                            .frame(width: 300, height: 20, alignment: .center)
                            .foregroundColor(Color.black)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                    }
                    */
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu{
                        Button("Settings") {
                            print("Settings tapped")
                        }
                        Button("Logout") {
                            print("Logout tapped!")
                            let defaults = UserDefaults.standard
                            defaults.set("", forKey: "uid") //Item like array
                            
                            
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                self.isLoggedOut = true
                                
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }
                        
                    }label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color("primaryColor"))
                    }
                    
                }
            }
            .navigationDestination(isPresented: $isLoggedOut) {
                HomeView()
                Text("")
                    .hidden()
            }
            .navigationDestination(isPresented: $isLyrics) {
                LyricsView(artist: artist, song: song, combinedLyrics: combinedLyrics)
            }
        }//NavigationStack
        .onAppear {
            self.isLoggedOut = false
            handleDefaultLanguage()
        }
    }//View
    func handleDefaultLanguage(){
        let defaults = UserDefaults.standard
        if let language = defaults.string(forKey: "defaultLanguage"), let name = defaults.string(forKey: "defaultLanguageName"){
            targetLanguage.language = language
            targetLanguage.name = name
        }else{
            //Make a api call
        }
    }
    func handleShazam(){
        
    }
    func handleQuickSearch(searchQuery: String, target: String) {
        
        let json: [String: String] = ["searchQuery": searchQuery, "target": target]
        let urlString = "http://localhost:8000/api/quicksearch"
        
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
                if let lyricsApiData: LyricsApiData = parseJSON(data){
                    Task {
                        self.lyrics = lyricsApiData.lyrics
                        self.artist = lyricsApiData.artist
                        self.song = lyricsApiData.song
                        
                        let isCombinedLyrics = await handleCombineLyrics(lyricsApiData)
                        if isCombinedLyrics{
                            //print(combinedLyrics) //if this print isn't here, on the first request the LyricsView will not be populated with Lyrics
                            updateRequestCounter()
                            self.isQuickSearchLoading = false
                            self.isLyrics = true
                        }else{
                            
                        }
                        
                        
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    func handleCombineLyrics(_ lyricsApiData: LyricsApiData) async -> Bool{
        if let translatedLyrics = lyricsApiData.translatedLyrics{
            self.lyricsArr = self.lyrics.components(separatedBy: "\n")
            let translatedLyricsArr = translatedLyrics.components(separatedBy: "\n")
            
            for i in 0..<max(self.lyricsArr.count, translatedLyricsArr.count) {
                if i < self.lyricsArr.count {
                    self.combinedLyrics.append(self.lyricsArr[i])
                }
                if i < translatedLyricsArr.count {
                    self.combinedLyrics.append(translatedLyricsArr[i])
                }
            }
            return true
        }else{
            return false
        }
        
        
    }
    
    func handleManualSearch(){
        
    }
    
    func parseJSON(_ lyricsData: Data) -> LyricsApiData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(LyricsApiData.self, from: lyricsData)
            return decodedData
        }catch {
            //delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
    func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    func updateRequestCounter(){
        let uid = getCurrentUser()
        
        let userRef = db.collection("users").document(uid)
            userRef.updateData(["requests": FieldValue.increment(Int64(1))]) { (error) in
                if error == nil {
                    print("updated")
                }else{
                    print("not updated")
                }
            }
    }
}

struct LoggedInHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInHomeView()
        
    }
}
