//
//  DeckView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import SwiftUI

struct DeckView: View {
    
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var decksViewHandler: DecksViewHandler = DecksViewHandler()
    
    let deck: Deck

    init(@ViewBuilder _ getDeck: () -> Deck) {
            self.deck = getDeck()
    }
    
    var body: some View{
        
        Button {
            
        } label: {
            HStack{
                let countDueCards = decksViewHandler.handleCountDueCards(cards: deck.cards ?? [])
                if countDueCards > 0{
                    Button {
                        decksViewHandler.handleSelectedADeck(deckName: deck.deckName, cards: deck.cards ?? [])
                    } label: {
                        Spacer()
                        Text(deck.deckName)
                            .bold()
                            .font(.system(size:24))
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("\(countDueCards)")
                            .foregroundColor(Color("secondaryColor"))
                    }
                }else{
                    Spacer()
                    Text(deck.deckName)
                        .bold()
                        .font(.system(size:24))
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("\(countDueCards)")
                        .foregroundColor(Color("primaryColor"))
                }
                
                Button {
                    appBrain.deckModel.selectedDeck.deckName = deck.deckName
                    appBrain.deckModel.selectedDeck.cards = deck.cards ?? []
                    appBrain.path.append("DeckSettingsView")
                } label: {
                    Image(systemName: "gearshape")
                        .bold()
                        .font(.system(size:24))
                        .foregroundColor(Color.white)
                }
            }
            .frame(width: 300, height: 20, alignment: .center)
            .padding()
            .background {
                Color("primaryColor")
            }
            .cornerRadius(18)
        }
        
    }
}
    
