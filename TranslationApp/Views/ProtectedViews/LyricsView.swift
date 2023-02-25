//
//  LyricsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import Foundation
import WrappingHStack
import WebKit
import FirebaseFirestore

struct LyricsView: View {
    var artist: String
    var song: String
    var combinedLyrics: [String]
    @State private var isBackButtonClicked = false
    @State private var isWebViewShown = false
    @State private var isAddToDeckViewShown = false
    
    @State private var urlString: String = "https://www.google.com"
    @State private var selectedWord: String = ""
    @EnvironmentObject var appBrain: AppBrain
    //@Binding var path: NavigationPath
    
    
    var body: some View {
        ZStack{
            Color("appColor")
            ScrollView{
                VStack(alignment: .leading){
                    Title(text: "Artist: \(artist)")
                    Title(text: "Song: \(song)")
                        .padding(.bottom)
                    ForEach(0..<self.combinedLyrics.count, id: \.self) { index in
                        if index % 2 == 0 {
                            let line = combinedLyrics[index]
                            let words = handleSplittingLine(line: line)
                            WrappingHStack(alignment: .leading){
                                ForEach(0..<words.count, id:\.self){ index in
                                    MenuSubView(
                                        word: String(words[index]),
                                        selectedWord: $selectedWord,
                                        urlString: $urlString,
                                        isWebViewShown: $isWebViewShown,
                                        color: "textColor",
                                        isAddToDeckViewShown: $isAddToDeckViewShown
                                    )
                                }
                            }
                        }else{
                            let line = combinedLyrics[index]
                            let words = handleSplittingLine(line: line)
                            WrappingHStack(alignment: .leading){
                                ForEach(0..<words.count, id:\.self){ index in
                                    MenuSubView(
                                        word: String(words[index]),
                                        selectedWord: $selectedWord,
                                        urlString: $urlString,
                                        isWebViewShown: $isWebViewShown,
                                        color: "secondaryColor",
                                        isAddToDeckViewShown: $isAddToDeckViewShown
                                    )
                                }
                            }//Closing WrappingHStack
                        }//Closing Else
                    }//Closing ForEach Line
                }//Closing VStack
            }//Closing Scroll View
            
            if isAddToDeckViewShown{
                AddWordView(isAddToDeckViewShown: $isAddToDeckViewShown, isWebViewShown: $isWebViewShown, back: selectedWord, selectedWord: $selectedWord)
            }
            if isWebViewShown {
                PopUpWebView(urlString: $urlString, isWebViewShown: $isWebViewShown)
            }
            
            
        }//Closing ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !isWebViewShown{
                    Button {
                        //self.appBrain.lyricsModel.combinedLyrics = []
                        self.isWebViewShown = false
                        //self.isBackButtonClicked = true
                        appBrain.path.removeLast()
                    } label: {
                        HStack{
                            Image(systemName: "arrow.left")
                            Text("Back")
                                .font(.system(size: 24))
                        }
                    }
                }
            }
        }//toolbar
    }//View
    func handleSplittingLine(line:String) -> [String]{
        let separator = CharacterSet(charactersIn: " \n")
        let words = line.components(separatedBy: separator).map { word -> String in
            if word.hasSuffix("\n") {
                return String(word.dropLast()) + "\n"
            } else {
                return word
            }
        }
        return words
    }
}//struct

struct LyricsView_Previews: PreviewProvider {
    static var previews: some View {
        LyricsView(artist: "Apache", song: "Roller", combinedLyrics: ["Hey now, you're an all star bleyblade day date\n", "Get your game on, go play\n", "c", "d"])
    }
}
struct AddWordView: View{
    let db = Firestore.firestore()
    @Binding var isAddToDeckViewShown: Bool
    @Binding var isWebViewShown: Bool
    @State private var front: String = ""
    @State var back: String
    @Binding var selectedWord: String
    @EnvironmentObject var appBrain: AppBrain
    
    var body: some View{
        ZStack{
            Color("secondaryColor")
            VStack{
                //Menu
                Menu{
                    ForEach(appBrain.decks, id: \.self) { deck in
                        Button {
                            appBrain.selectedDeck.deckName = deck.deckName
                            //appBrain.selectedDeck.cards = deck.cards
                        } label: {
                            Text(deck.deckName)
                        }
                    }
                } label: {
                    Label(
                        title: {Text("Selected Deck: \(appBrain.selectedDeck.deckName)")
                                .font(.system(size:24))
                                .bold()
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color("textColor"))
                                .padding()
                                .background {
                                    Color("primaryColor")
                                }
                                .cornerRadius(18)
                        },
                        icon: { Image(systemName: "")}
                    )
                }
                
                //Front
                TextField(text: self.$front){
                    Text("Front").foregroundColor(.gray)
                }
                .font(.system(size:18))
                .frame(width: 300, height: 20, alignment: .center)
                .foregroundColor(Color.black)
                .padding()
                .background {
                    Color("inputColor")
                }
                .cornerRadius(18)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                
                //Back
                TextField(text: self.$back){
                    Text("Back").foregroundColor(.gray)
                }
                .font(.system(size:18))
                .frame(width: 300, height: 20, alignment: .center)
                .foregroundColor(Color.black)
                .padding()
                .background {
                    Color("inputColor")
                }
                .cornerRadius(18)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                //Google
                Button {
                    isWebViewShown.toggle()
                } label: {
                    Text("Google Meaning")
                        .font(.system(size:24))
                        .bold()
                        .frame(width: 300, height: 20, alignment: .center)
                        .foregroundColor(Color("textColor"))
                        .padding()
                        .background {
                            Color("primaryColor")
                        }
                        .cornerRadius(18)
                    
                    
                }
                //Add or cancel
                HStack{
                    Button {
                        isAddToDeckViewShown.toggle()
                    } label: {
                        Text("Cancel")
                            .font(.system(size:24))
                            .bold()
                            .frame(width: 120, height: 20, alignment: .center)
                            .foregroundColor(Color.red)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                        
                        
                    }
                    Button {
                        var _ = appBrain.handleAddToDeck(front: self.front, back: self.back)
                        isAddToDeckViewShown.toggle()
                    } label: {
                        Text("Add")
                            .font(.system(size:24))
                            .bold()
                            .frame(width: 120, height: 20, alignment: .center)
                            .foregroundColor(Color.green)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                    }
                }
            }
        }
        .frame(width: 350, height: 400)
        .cornerRadius(10)
    }    
}
struct PopUpWebView: View{
    @Binding var urlString: String
    @Binding var isWebViewShown: Bool
    var body: some View{
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                WebView(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!)
                //.frame(height: 500.0)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 20.0, x: 5, y: 5)
                
                Button("Close") {
                    self.isWebViewShown = false
                }
                .padding()
            }
            //.padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 20)
        }
    }
}
struct WebView: UIViewRepresentable{
    var url: URL
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context){
        let request = URLRequest(url:url)
        uiView.load(request)
    }
}

struct Title: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 24))
            .bold()
    }
}

struct MenuSubView: View {
    var word : String
    @Binding var selectedWord: String
    @Binding var urlString: String
    @Binding var isWebViewShown: Bool
    var color : String
    @Binding var isAddToDeckViewShown: Bool
    
    var body: some View {
        Menu{
            Button {
                selectedWord = word
                urlString = "https://www.google.com/search?q=\(selectedWord)+meaning"
                isAddToDeckViewShown.toggle()
            } label: {
                Text("Add to deck")
            }
            Button {
                selectedWord = word
                urlString = "https://www.google.com/search?q=\(selectedWord)+meaning"
                isWebViewShown.toggle()
            } label: {
                Text("Google Meaning")
            }
        } label: {
            Text(word)
                .font(.system(size:18))
                .bold()
                .foregroundColor(Color(color))
                .padding(.trailing, 2)
        }
    }
}
