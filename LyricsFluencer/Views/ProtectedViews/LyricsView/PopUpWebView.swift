//
//  PopUpWebView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI
import WebKit

struct PopUpWebView: View{
    
    @StateObject var lyricsViewController: LyricsViewController
    
    var body: some View{
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                WebView(url: URL(string: lyricsViewController.urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 20.0, x: 5, y: 5)
                
                Button("Close") {
                    self.lyricsViewController.isWebViewShown = false
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
