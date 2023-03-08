//
//  CardView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 24.02.23.
//

import SwiftUI
import FirebaseFirestore

struct CardView: View {
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var cardViewHandler: CardViewHandler = CardViewHandler()
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                if cardViewHandler.filteredDeck.count != 0 && cardViewHandler.index < cardViewHandler.filteredDeck.count{
                    Text(cardViewHandler.filteredDeck[cardViewHandler.index].front)
                    //Show all Cards
                    /*
                    ForEach(appBrain.decks.filter { $0.deckName == appBrain.selectedDeck.deckName }.first?.cards ?? []) { card in
                        Text(card.front)
                            .foregroundColor(Color.white)
                        Text("\(card.due)")
                            .foregroundColor(Color.white)
                    }*/
                    if cardViewHandler.isFrontClicked{
                        Text(cardViewHandler.filteredDeck[cardViewHandler.index].back)
                    }
                }
            }
        }
        .onTapGesture {
            self.cardViewHandler.isFrontClicked.toggle()
        }
        .onAppear{
            cardViewHandler.handleFilteringForDueCards(appBrain: appBrain)
        }
        if cardViewHandler.isFrontClicked && cardViewHandler.index < cardViewHandler.filteredDeck.count{
            ZStack{
                HStack{
                    Button {
                        self.cardViewHandler.handleAgain()
                    } label: {
                        Text("Again")
                            .font(.system(size:24))
                            .bold()
                            .frame(width: 120, height: 20, alignment: .center)
                            .foregroundColor(Color.red)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                    }
                    Button {
                        self.cardViewHandler.handleGood(appBrain: appBrain)
                    } label: {
                        Text("Good")
                            .font(.system(size:24))
                            .bold()
                            .frame(width: 120, height: 20, alignment: .center)
                            .foregroundColor(Color.green)
                            .padding()
                            .background {
                                Color("primaryColor")
                            }
                            .cornerRadius(18)
                    }
                    
                }
                
            }
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
