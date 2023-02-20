//
//  LyricsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import Foundation
import WrappingHStack

struct LyricsView: View {
    var artist: String
    var song: String
    var combinedLyrics: [String]
    @State private var isBackButtonClicked = false
    
    var body: some View {
        ZStack{
            Color("appColor")
            ScrollView{
                VStack(alignment: .leading){
                    Text("Artist: \(artist)")
                        .font(.system(size: 24))
                        .bold()
                    Text("Song: \(song)")
                        .font(.system(size: 24))
                        .bold()
                        .padding(.bottom)
                    ForEach(0..<self.combinedLyrics.count, id: \.self) { index in
                        if index % 2 == 0 {
                            let line = combinedLyrics[index]
                            let separator = CharacterSet(charactersIn: " \n")
                            let words = line.components(separatedBy: separator).map { word -> String in
                                if word.hasSuffix("\n") {
                                    return String(word.dropLast()) + "\n"
                                } else {
                                    return word
                                }
                            }
                            WrappingHStack(alignment: .leading){
                                ForEach(0..<words.count, id:\.self){ index in
                                    Menu{
                                        Button {
                                            print("Pressed")
                                        } label: {
                                            Text("Add to deck")
                                        }
                                        Button {
                                            print("Pressed")
                                        } label: {
                                            Text("Google Meaning")
                                        }
                                    } label: {
                                        Text(String(words[index]))
                                            .font(.system(size:18))
                                            .bold()
                                            .foregroundColor(Color("textColor"))
                                    }
                                }
                            }
                        }else{
                            let line = combinedLyrics[index]
                            //let words = line.components(separatedBy: [" ", "\n"])
                            let separator = CharacterSet(charactersIn: " \n")
                            let words = line.components(separatedBy: separator).map { word -> String in
                                if word.hasSuffix("\n") {
                                    return String(word.dropLast()) + "\n"
                                } else {
                                    return word
                                }
                            }
                            WrappingHStack(alignment: .leading){
                                ForEach(0..<words.count, id:\.self){ index in
                                    Menu{
                                        Button {
                                            print("Pressed")
                                        } label: {
                                            Text("Add to deck")
                                        }
                                        Button {
                                            print("Pressed")
                                        } label: {
                                            Text("Google Meaning")
                                        }
                                    } label: {
                                        Text(String(words[index]))
                                            .font(.system(size:18))
                                            .bold()
                                            .foregroundColor(Color("primaryColor"))
                                    }
                                    
                                }
                            }//Closing WrappingHStack
                        }//Closing Else
                    }//Closing ForEach
                }//Closing VStack
            }//Closing Scroll View
        }//Closing ZStack
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.isBackButtonClicked = true
                } label: {
                    HStack{
                        Image(systemName: "arrow.left")
                        Text("Back")
                            .font(.system(size: 24))
                    }
                }
            }
        }//toolbar
        .navigationDestination(isPresented: $isBackButtonClicked) {
            HomeView()
        }
        .onAppear {
            self.isBackButtonClicked = false
        }
    }//View
}//struct

struct LyricsView_Previews: PreviewProvider {
    static var previews: some View {
        LyricsView(artist: "Apache", song: "Roller", combinedLyrics: ["Hey now, you're an all star bleyblade day date\n", "Get your game on, go play\n", "c", "d"])
    }
}
