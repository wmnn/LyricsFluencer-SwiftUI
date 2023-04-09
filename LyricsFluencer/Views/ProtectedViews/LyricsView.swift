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
                .ignoresSafeArea(.all)
                ScrollView{
                    VStack(alignment: .leading){
                        Title(text: "Artist: \(appBrain.lyricsModel.artist ?? " ")")
                        Title(text: "Song: \(appBrain.lyricsModel.song ?? " ")")
                            .padding(.bottom)
                        
                        
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
                            }//ELSE
                        }
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
        LyricsView()

    }
}
struct MenuSubView: View {
    var word : String
    var color : String
    @StateObject var lyricsViewHandler: LyricsViewHandler
    @EnvironmentObject var appBrain: AppBrain
    
    var body: some View {
        Menu{
            Button {
                lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                lyricsViewHandler.front = ""
                lyricsViewHandler.back = lyricsViewHandler.cleanWord(word)
                lyricsViewHandler.urlString = "https://www.google.com/search?q=\(lyricsViewHandler.cleanWord(word))+\(appBrain.getLanguageName(appBrain.lyricsModel.detectedLanguage.language)?.lowercased() ?? "show")+meaning"
                lyricsViewHandler.isAddToDeckViewShown.toggle()
            } label: {
                Text("Add to deck")
            }
            Button {
                lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                lyricsViewHandler.urlString = "https://www.google.com/search?q=\(lyricsViewHandler.cleanWord(word))+\(appBrain.getLanguageName(appBrain.lyricsModel.detectedLanguage.language)?.lowercased() ?? "show")+meaning"
                lyricsViewHandler.isWebViewShown.toggle()
            } label: {
                Text("Google Meaning")
            }
            
            Button {
                lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                print("https://translate.google.com/?sl=\(appBrain.lyricsModel.detectedLanguage.language)&tl=\(appBrain.user.nativeLanguage.language)&text=\(lyricsViewHandler.cleanWord(word).lowercased())&op=translate")
                lyricsViewHandler.urlString = "https://translate.google.com/?sl=\(appBrain.lyricsModel.detectedLanguage.language)&tl=\(appBrain.user.nativeLanguage.language)&text=\(lyricsViewHandler.cleanWord(word).lowercased())&op=translate"
                lyricsViewHandler.isWebViewShown.toggle()
            } label: {
                Text("Google Translate")
            }
            
            ForEach(0..<STATIC.languages.count, id: \.self) { i in
                if STATIC.languages[i].language == appBrain.lyricsModel.detectedLanguage.language{
                    Button {
                        lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                        print( self.appBrain.getLanguageName(self.appBrain.lyricsModel.detectedLanguage.language) ?? "")
                        lyricsViewHandler.urlString = "https://conjugator.reverso.net/conjugation-\(appBrain.getLanguageName(appBrain.lyricsModel.detectedLanguage.language)?.lowercased() ?? "english")-verb-\(lyricsViewHandler.cleanWord(word)).html"
                        lyricsViewHandler.isWebViewShown.toggle()
           
                    } label: {
                        Text("Show Conjugation (only on Verbs)")
                    }
                }
            }
            /*
                Button {
                    lyricsViewHandler.selectedWord = lyricsViewHandler.cleanWord(word)
                    print( self.appBrain.getLanguageName(self.appBrain.lyricsModel.detectedLanguage.language) ?? "")
                    lyricsViewHandler.urlString = "https://conjugator.reverso.net/conjugation-\(appBrain.getLanguageName(appBrain.lyricsModel.detectedLanguage.language)?.lowercased() ?? "english")-verb-\(lyricsViewHandler.cleanWord(word)).html"
                    lyricsViewHandler.isWebViewShown.toggle()
       
                } label: {
                    Text("Show Conjugation (only on Verbs)")
                }
            
            */
            
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
}/*
  struct WebView: UIViewRepresentable{
  var url: URL
  func makeUIView(context: Context) -> WKWebView{
  return WKWebView()
  }
  func updateUIView(_ uiView: WKWebView, context: Context){
  let request = URLRequest(url:url)
  uiView.load(request)
  }
  }*/
class WebViewDelegate: NSObject, WKNavigationDelegate {
    let allowedHosts: [String] = ["https://www.google.com/*", "www.google.com", "consent.google.com", "dictionary.cambridge.org/*", "conjugator.reverso.net/*", "conjugator.reverso.net", "context.reverso.net", "context.reverso.net/*", "www.hinative.com/*", "en.m.wiktionary.org/*", "www.italki.com/*", "translate.google.com", "translate.google.com/*"]
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if allowedHosts.contains(url.host ?? "") {
            decisionHandler(.allow)
        } else {
            print(url.host ?? "")
            //print(allowedHosts)
            decisionHandler(.cancel)
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    let delegate: WebViewDelegate
    
    init(url: URL) {
        self.url = url
        self.delegate = WebViewDelegate()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = delegate
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
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
