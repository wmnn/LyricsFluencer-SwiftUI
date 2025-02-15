//
//  FlashcardsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 23.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DecksView: View {
    
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var deckContext: DeckContext
    @StateObject var decksViewHandler: DecksViewHandler = DecksViewHandler()
    
    var body: some View {
        //NavigationStack(path: $decksPath){
        //Instead Navigating Thorugh a new navigation path, navigation through a constant navigation path and passing the data to the view through a environment object, the cards arr gives headache converting it to a hashable and equatable property
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                ForEach(deckContext.decks) { deck in
                    DeckView(deck: deck)
                }
                
                //Create a new deck Button
                Button {
                    self.decksViewHandler.showCreateDeckAlert.toggle()
                } label: {
                    TextWithIcon(text: "Add Deck", systemName: "plus")
                }
                
                //Create a new deck alert
                .alert("Create deck", isPresented: $decksViewHandler.showCreateDeckAlert, actions: {
                    TextField("Deckname", text: $decksViewHandler.createDeckName)
                    Button("Create Deck", action: {
                        deckContext.createDeck(deckName: self.decksViewHandler.createDeckName)
                        DispatchQueue.main.async {
                            self.decksViewHandler.createDeckName = ""
                        }
                    })
                    Button("Cancel", role: .cancel, action: {})
                    
                }, message: {
                    Text("Provide a deckname.")
                })
            }
        }
    }
}

struct FlashcardsView_Previews: PreviewProvider {
    static let appBrain = AppContext()
    static var previews: some View {
        DecksView()
            .environmentObject(appBrain)
    }
}

