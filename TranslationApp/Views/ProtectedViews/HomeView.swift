//
//  LoggedInHomeView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View{
    @EnvironmentObject var appBrain: AppBrain
    @Binding var path: NavigationPath
    @State private var homePath = NavigationPath()
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    var body: some View {
        //NavigationStack(path: $homePath){
        ZStack{
            Color("appColor")
                .ignoresSafeArea()
            VStack{
                if appBrain.isTrialExpired {
                    Text("Your free trial has expired, unfortunately you can't subscribe inside the app.")
                        .foregroundColor(Color("textColor"))
                        .font(.system(size:24))
                        .bold()
                }
                //Handling target language
                LanguagesMenu()
                //handling Shazam
                if appBrain.isTrialExpired {
                    TrialExpiredButton(text: "Recognize Song")
                }else{
                    Button {
                        handleShazam()
                        appBrain.isShazamLoading.toggle()
                        updateRequestCounter()
                    } label: {
                        if appBrain.isShazamLoading {
                            ActivityIndicatorButton()
                        }else{
                            ButtonWithIcon(text: "Recognize Song ", systemName: "shazam.logo.fill")
                        }
                    }
                }
                //handling Quicksearch Input
                Input(placeholderText: "Search")
                //handling Quicksearch
                if appBrain.isTrialExpired {
                    TrialExpiredButton(text: "Quick Search")
                }else{
                    Button {
                        handleQuickSearch(searchQuery: appBrain.searchQuery, target: appBrain.targetLanguage.language)
                    } label: {
                        if appBrain.isQuickSearchLoading {
                            ActivityIndicatorButton()
                        } else{
                            ButtonWithIcon(text: "Quick Search", systemName: "magnifyingglass")
                        }
                    }
                }//else
            }//Closing VStack
        }//Closing ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu{
                    Button("Settings") {
                        //print("Settings tapped")
                    }
                    Button("Logout") {
                        logout()
                    }
                }label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color("primaryColor"))
                }
            }
        }
        .onAppear(perform: {
            appBrain.handleTrial()
        })
    }
    func handleShazam(){
        
    }
    func handleQuickSearch(searchQuery: String, target: String) {
        self.appBrain.isQuickSearchLoading = true
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
                            self.appBrain.lyricsModel.lyrics = lyricsApiData.lyrics
                            self.appBrain.lyricsModel.artist = lyricsApiData.artist
                            self.appBrain.lyricsModel.song = lyricsApiData.song
                            
                            let isCombinedLyrics = await self.handleCombineLyrics(lyricsApiData)
                            if isCombinedLyrics{
                                print("inside is combined lyrics")
                                self.updateRequestCounter()
                                self.appBrain.isQuickSearchLoading = false
                                DispatchQueue.main.async {
                                    path.append("Lyrics")
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
        self.appBrain.lyricsModel.combinedLyrics = []
        if let translatedLyrics = lyricsApiData.translatedLyrics{
            if let lyrics = self.appBrain.lyricsModel.lyrics{
                let lyricsArr = lyrics.components(separatedBy: "\n")
                let translatedLyricsArr = translatedLyrics.components(separatedBy: "\n")
                DispatchQueue.main.async {
                    for i in 0..<max(lyricsArr.count, translatedLyricsArr.count) {
                        if i < lyricsArr.count {
                            self.appBrain.lyricsModel.combinedLyrics?.append(lyricsArr[i])
                        }
                        if i < translatedLyricsArr.count {
                            self.appBrain.lyricsModel.combinedLyrics?.append(translatedLyricsArr[i])
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
                self.appBrain.handleTrial()
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
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.appBrain.handleDeleteLocalStorage()
            self.path = NavigationPath()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct LoggedInHomeView_Previews: PreviewProvider {
    static let appBrain = AppBrain()
    @State private var homePath = NavigationPath()
    
    static var previews: some View {
        HomeView(path: .constant(NavigationPath())
        )
        .environmentObject(appBrain)
    }
}

struct TrialExpiredButton: View{
    var text: String
    var body: some View{
        HStack{
            Text(text)
            Image(systemName: "lock")
        }
        .font(.system(size:24))
        .bold()
        .frame(width: 300, height: 20, alignment: .center)
        .foregroundColor(Color.black)
        .padding()
        .background {
            Color.gray
        }
        .cornerRadius(18)
    }
}
struct ActivityIndicatorButton: View{
    var body: some View{
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
        
    }
}
struct ButtonWithIcon: View{
    var text: String
    var systemName: String
    var body: some View{
        HStack{
            Text(text)
            Image(systemName: systemName)
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
struct LanguagesMenu: View{
    @EnvironmentObject var appBrain: AppBrain
    
    var body: some View{
        Menu{
            ForEach(0..<STATIC.languages.count, id: \.self) { index in
                Button {
                    appBrain.targetLanguage.language = STATIC.languages[index].language
                    appBrain.targetLanguage.name = STATIC.languages[index].name
                } label: {
                    Text(STATIC.languages[index].name)
                }
            }
        } label: {
            Label(
                title: {Text("Target language: \(appBrain.targetLanguage.name)")
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
        
    }
}
struct Input: View{
    @EnvironmentObject var appBrain: AppBrain
    var placeholderText: String
    
    var body: some View{
        TextField(text: $appBrain.searchQuery){
            Text(placeholderText).foregroundColor(Color.gray)
        }
        .font(.system(size:24))
        .frame(width: 300, height: 20, alignment: .center)
        .padding()
        .foregroundColor(Color.black)
        .background{
            Color("inputColor")
        }
        .cornerRadius(18)
    }
}
