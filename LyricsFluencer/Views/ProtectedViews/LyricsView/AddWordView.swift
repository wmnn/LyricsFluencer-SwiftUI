//
//  AddWordView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI
import FirebaseFirestore

struct AddWordView: View{
    
    let db = Firestore.firestore()
    @EnvironmentObject var appBrain: AppBrain
    @EnvironmentObject var deckContext: DeckContext
    @StateObject var lyricsViewHandler: LyricsViewHandler
    
    var body: some View{
        ZStack{
            //Color("secondaryColor")
            VStack{
                //Menu
                Menu{
                    ForEach(deckContext.decks, id: \.self) { deck in
                        Button {
                            deckContext.selectedDeck.deckName = deck.deckName
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
                            Text("Selected Deck: \(deckContext.selectedDeck.deckName)")
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
                        var _ = deckContext.handleAddToDeck(front: self.lyricsViewHandler.front, back: self.lyricsViewHandler.back)
                        lyricsViewHandler.isAddToDeckViewShown.toggle()
                    }, textColor: Color.green)
                    
                }
            }
        }
        .frame(width: 350, height: 400)
        .cornerRadius(10)
        .onAppear{
            if deckContext.selectedDeck.deckName == ""&&deckContext.decks.count > 0{
                deckContext.selectedDeck.deckName = deckContext.decks[0].deckName
            }
        }
        .alert("Create deck", isPresented: $lyricsViewHandler.showCreateDeckAlert, actions: {
            TextField("Deckname", text: $lyricsViewHandler.createDeckName)
            Button("Create Deck", action: {
                deckContext.createDeck(deckName: self.lyricsViewHandler.createDeckName)
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
