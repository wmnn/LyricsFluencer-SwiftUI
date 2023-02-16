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
    
    struct WordIndex: Equatable {
        let line: Int
        let word: Int
    }
    
    
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
                    
                    /*ForEach(0..<self.combinedLyrics.count, id: \.self) { index in
                        Text(self.combinedLyrics[index])
                            .foregroundColor(index % 2 == 0 ? Color("textColor") : Color("primaryColor"))
                            .font(.system(size: 24))
                        
                    }*/
                        
                     
                    //
                }
              
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.isBackButtonClicked.toggle()
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
            LoggedInHomeView()
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


