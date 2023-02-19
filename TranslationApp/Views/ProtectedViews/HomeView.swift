//
//  LoggedInHomeView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI

struct HomeView: View{
    @EnvironmentObject var appBrain: AppBrain
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("appColor")
                    .ignoresSafeArea()
                VStack{
                    if appBrain.isTrialExpired {
                        Text("Your free trial has expired, unfortunately you can't subscribe inside the app.")
                            .foregroundColor(Color("textColor"))
                            .font(.system(size:24))
                            .bold()
                    }else{
                        //Text(String(appBrain.isTrialExpired))
                    }
                    
                    //Handling target language
                    Menu{
                        ForEach(0..<Constants.languages.count, id: \.self) { index in
                            Button {
                                appBrain.targetLanguage.language = Constants.languages[index].language
                                appBrain.targetLanguage.name = Constants.languages[index].name
                            } label: {
                                Text(Constants.languages[index].name)
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
                    //handling Shazam
                    if appBrain.isTrialExpired {
                            HStack{
                                Text("Recognize Song ")
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
                    }else{
                        Button {
                            appBrain.handleShazam()
                            appBrain.isShazamLoading.toggle()
                            appBrain.updateRequestCounter()
                        } label: {
                            if appBrain.isShazamLoading {
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
                                    title: {
                                        Text("Recognize Song ")
                                    }, icon: {
                                        Image(systemName: "shazam.logo.fill")
                                    })
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
                    }
                    //handling Quicksearch Input
                    TextField(text: $appBrain.searchQuery){
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
                    
                    //handling Quicksearch
                    if appBrain.isTrialExpired {
                            HStack{
                                Text("Quick Search ")
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
                    }else{
                        Button {
                            appBrain.handleQuickSearch(searchQuery: appBrain.searchQuery, target: appBrain.targetLanguage.language)
                        } label: {
                            if appBrain.isQuickSearchLoading {
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
                    }//else
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu{
                        Button("Settings") {
                            //print("Settings tapped")
                        }
                        Button("Logout") {
                            appBrain.logout()
                        }
                    }label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color("primaryColor"))
                    }
                }
            }
            .navigationDestination(isPresented: $appBrain.isLoggedOut) {
                RegisterView()
            }
            .navigationDestination(isPresented: $appBrain.isLyrics) {
                if let artist = appBrain.lyricsModel.artist, let song = appBrain.lyricsModel.song, let combinedLyrics = appBrain.lyricsModel.combinedLyrics{
                    LyricsView(artist: artist, song: song, combinedLyrics: combinedLyrics)
                }
            }
              
        }//NavigationStack
        .onAppear(perform: {
            appBrain.handleTrial()
            appBrain.isLoggedOut = false
        })
    }//View
}

struct LoggedInHomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}

