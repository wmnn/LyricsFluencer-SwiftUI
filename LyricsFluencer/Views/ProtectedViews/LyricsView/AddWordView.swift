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
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var deckContext: DeckContext
    @StateObject var lyricsViewController: LyricsViewController
    
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
                        self.lyricsViewController.showCreateDeckAlert = true
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
                SomeTextField(binding: $lyricsViewController.front, placeholder: "Front")
                //Back
                SomeTextField(binding: $lyricsViewController.back, placeholder: "Back")
                //Google
                SomeButton(text: "Google Meaning", buttonAction:{
                    lyricsViewController.isWebViewShown.toggle()
                }, systemName: "magnifyingglass")
                //Add or cancel
                HStack{
                    SomeSmallButton(text: "Cancel", buttonAction: {
                        lyricsViewController.isAddToDeckViewShown.toggle()
                    }, textColor: Color.red)
                    
                    SomeSmallButton(text: "Add", buttonAction: {
                        var _ = deckContext.handleAddToDeck(front: self.lyricsViewController.front, back: self.lyricsViewController.back)
                        lyricsViewController.isAddToDeckViewShown.toggle()
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
        .alert("Create deck", isPresented: $lyricsViewController.showCreateDeckAlert, actions: {
            TextField("Deckname", text: $lyricsViewController.createDeckName)
            Button("Create Deck", action: {
                deckContext.createDeck(deckName: self.lyricsViewController.createDeckName)
                DispatchQueue.main.async {
                    self.lyricsViewController.createDeckName = ""
                    self.lyricsViewController.showCreateDeckAlert = false
                }
            })
            Button("Cancel", role: .cancel, action: {
                self.lyricsViewController.showCreateDeckAlert = false
            })
            
        }, message: {
            Text("Provide a deckname.")
        })
    }
}
