//
//  CardView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 24.02.23.
//

import SwiftUI
import FirebaseFirestore

struct CardView: View {
    
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var cardContext: CardContext
    @EnvironmentObject var deckContext: DeckContext
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                if cardContext.filteredDeck.count != 0 && cardContext.currentIdxInFilteredDeck < cardContext.filteredDeck.count{
                    
                    Text(cardContext.filteredDeck[cardContext.currentIdxInFilteredDeck].front)
                    
                    if cardContext.isFrontClicked{
                        Text(cardContext.filteredDeck[cardContext.currentIdxInFilteredDeck].back)
                    }
                }
            }
        }
        .onTapGesture {
            self.cardContext.isFrontClicked.toggle()
        }
        .onAppear{
            self.cardContext.appBrain = self.appBrain
            self.cardContext.deckContext = self.deckContext
            cardContext.handleFilteringForDueCards()
        }
        
        if cardContext.isFrontClicked && cardContext.currentIdxInFilteredDeck < cardContext.filteredDeck.count {
            
            ZStack{
                HStack{
                    Button {
                        self.cardContext.handleAgain()
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
                        self.cardContext.handleGood()
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
