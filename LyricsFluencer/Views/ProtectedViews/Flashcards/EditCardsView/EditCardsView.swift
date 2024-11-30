//
//  EditCardsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import SwiftUI

struct EditCardsView: View {
    
    @EnvironmentObject var cardContext: CardContext
    @EnvironmentObject var deckContext: DeckContext
    @StateObject var editCardViewHandler = EditCardsViewHandler()
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(deckContext.selectedDeck.cards ?? []) { card in
                    EditCardsViewCard(card: card)
                }
            }
        }
        .navigationTitle(deckContext.selectedDeck.deckName)
        .onAppear{
            self.editCardViewHandler.cardContext = self.cardContext
            self.cardContext.deckContext = self.deckContext
        }
    }
}

struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
