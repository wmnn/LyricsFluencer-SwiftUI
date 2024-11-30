//
//  DeckView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import SwiftUI

struct DeckView: View {
    
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var deckContext: DeckContext
    @StateObject var decksViewHandler: DecksViewHandler = DecksViewHandler()
    
    let deck: Deck
    
    var body: some View{
        
        Button {
            
        } label: {
            HStack{
                let countDueCards = deckContext.handleCountDueCards(deck)
                if countDueCards > 0{
                    Button {
                        deckContext.selectedDeck = deck
                        self.appBrain.navigate(to: Views.CardsView)
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
                } else {
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
                    deckContext.selectedDeck = deck;
                    appBrain.navigate(to: Views.DeckSettingsView)
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
    
