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
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var lyricsViewHandler = LyricsViewHandler()
    
    var body: some View {
        ZStack{
            Color.background
            ScrollView{
                VStack(alignment: .leading){
                    Title(text: "Artist: \(appBrain.lyricsModel.artist ?? " ")")
                    Title(text: "Song: \(appBrain.lyricsModel.song ?? " ")")
                        .padding(.bottom)
                    if appBrain.lyricsModel.albumArtURL != nil{
                        AsyncImage(url: appBrain.lyricsModel.albumArtURL){ image in
                            image
                                .resizable()
                                .scaledToFit()
                                .opacity(1)
                                .frame(width: 200, height: 200)
                        } placeholder: {
                            EmptyView()
                        }
                    }
                   
                    
                    ForEach(0..<self.appBrain.lyricsModel.combinedLyrics!.count, id: \.self) { index in
                        if index % 2 == 0 {
                            let line = appBrain.lyricsModel.combinedLyrics![index]
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
                            let line = appBrain.lyricsModel.combinedLyrics![index]
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
            
            if lyricsViewHandler.isAddToDeckViewShown || lyricsViewHandler.isWebViewShown{
                ZStack{
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                    Color.black.opacity(0.4).ignoresSafeArea(.all)
                }
                .edgesIgnoringSafeArea(.all)
            }
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
                if !lyricsViewHandler.isWebViewShown && !lyricsViewHandler.isAddToDeckViewShown{
                    Button {
                        self.lyricsViewHandler.isWebViewShown = false
                        appBrain.lyricsModel.albumArtURL = nil
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
        LyricsView(/*artist: "Apache", song: "Roller", combinedLyrics: ["Hey now, you're an all star bleyblade day date\n", "Get your game on, go play\n", "c", "d"]*/)
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
            //Color("secondaryColor")
            VStack{
                //Menu
                Menu{
                    ForEach(appBrain.user.decks, id: \.self) { deck in
                        Button {
                            appBrain.user.selectedDeck.deckName = deck.deckName
                        } label: {
                            Text(deck.deckName)
                        }
                    }
                    //if appBrain.decks.count == 0 {
                    Button {
                        self.lyricsViewHandler.showCreateDeckAlert = true
                    } label: {
                        Text("Create a new deck")
                    }
                    //}
                } label: {
                    Label(
                        title: {
                            Text("Selected Deck: \(appBrain.user.selectedDeck.deckName)")
                                .font(.system(size:24))
                                .bold()
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color.white)
                                .padding()
                                .background {
                                    Color.primary
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
                SomeButton(text: "Google Meaning", buttonAction:{
                    lyricsViewHandler.isWebViewShown.toggle()
                }, systemName: "magnifyingglass")
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
        .onAppear{
            if appBrain.user.selectedDeck.deckName == ""&&appBrain.user.decks.count > 0{
                appBrain.user.selectedDeck.deckName = appBrain.user.decks[0].deckName
            }
        }
        .alert("Create deck", isPresented: $lyricsViewHandler.showCreateDeckAlert, actions: {
            TextField("Deckname", text: $lyricsViewHandler.createDeckName)
            Button("Create Deck", action: {
                appBrain.createDeck(deckName: self.lyricsViewHandler.createDeckName)
                DispatchQueue.main.async {
                    self.lyricsViewHandler.createDeckName = ""
                    self.lyricsViewHandler.showCreateDeckAlert = false
                }
            })
            Button("Cancel", role: .cancel, action: {
                self.lyricsViewHandler.showCreateDeckAlert = false
            })
            
        }, message: {
            Text("Provide a deckname.")
        })
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

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
