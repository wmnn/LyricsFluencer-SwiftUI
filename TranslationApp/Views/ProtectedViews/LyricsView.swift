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
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var lyricsViewHandler = LyricsViewHandler()
    
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
                            let words = lyricsViewHandler.handleSplittingLine(line: line)
                            WrappingHStack(alignment: .leading){
                                ForEach(0..<words.count, id:\.self){ index in
                                    MenuSubView(
                                        word: String(words[index]),
                                        color: "textColor",
                                        lyricsViewHandler: lyricsViewHandler
                                    )
                                }
                            }
                        }else{
                            let line = combinedLyrics[index]
                            let words = lyricsViewHandler.handleSplittingLine(line: line)
                            WrappingHStack(alignment: .leading){
                                ForEach(0..<words.count, id:\.self){ index in
                                    MenuSubView(
                                        word: String(words[index]),
                                        color: "secondaryColor",
                                        lyricsViewHandler: lyricsViewHandler
                                    )
                                }
                            }//Closing WrappingHStack
                        }//Closing Else
                    }//Closing ForEach Line
                }//Closing VStack
            }//Closing Scroll View
            
            if lyricsViewHandler.isAddToDeckViewShown{
                AddWordView(lyricsViewHandler: lyricsViewHandler)
            }
            if lyricsViewHandler.isWebViewShown {
                PopUpWebView(lyricsViewHandler: lyricsViewHandler)
            }
            
            
        }//Closing ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !lyricsViewHandler.isWebViewShown{
                    Button {
                        self.lyricsViewHandler.isWebViewShown = false
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
}//struct

struct LyricsView_Previews: PreviewProvider {
    static var previews: some View {
        LyricsView(artist: "Apache", song: "Roller", combinedLyrics: ["Hey now, you're an all star bleyblade day date\n", "Get your game on, go play\n", "c", "d"])
    }
}
struct MenuSubView: View {
    var word : String
    var color : String
    @StateObject var lyricsViewHandler: LyricsViewHandler
    
    var body: some View {
        Menu{
            Button {
                lyricsViewHandler.selectedWord = word
                lyricsViewHandler.back = word
                lyricsViewHandler.urlString = "https://www.google.com/search?q=\(word)+meaning"
                lyricsViewHandler.isAddToDeckViewShown.toggle()
            } label: {
                Text("Add to deck")
            }
            Button {
                lyricsViewHandler.selectedWord = word
                lyricsViewHandler.urlString = "https://www.google.com/search?q=\(word)+meaning"
                lyricsViewHandler.isWebViewShown.toggle()
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

struct AddWordView: View{
    let db = Firestore.firestore()
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var lyricsViewHandler: LyricsViewHandler
    
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
                SomeTextField(binding: $lyricsViewHandler.front, placeholder: "Front")
                //Back
                SomeTextField(binding: $lyricsViewHandler.back, placeholder: "Back")
                //Google
                SomeButton(text: "Google Meaning") {
                    lyricsViewHandler.isWebViewShown.toggle()
                }
                //Add or cancel
                HStack{
                    SomeSmallButton(text: "Cancel", buttonAction: {
                        lyricsViewHandler.isAddToDeckViewShown.toggle()
                    }, textColor: Color.red)
                    
                    SomeSmallButton(text: "Add", buttonAction: {
                        var _ = appBrain.handleAddToDeck(front: self.lyricsViewHandler.front, back: self.lyricsViewHandler.back)
                        lyricsViewHandler.isAddToDeckViewShown.toggle()
                    }, textColor: Color.green)
                }
            }
        }
        .frame(width: 350, height: 400)
        .cornerRadius(10)
    }    
}
struct PopUpWebView: View{
    @StateObject var lyricsViewHandler: LyricsViewHandler
    
    var body: some View{
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                WebView(url: URL(string: lyricsViewHandler.urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 20.0, x: 5, y: 5)
                
                Button("Close") {
                    self.lyricsViewHandler.isWebViewShown = false
                }
                .padding()
            }
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
