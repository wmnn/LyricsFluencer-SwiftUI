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
    @StateObject var cardViewHandler: CardViewHandler = CardViewHandler()
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                if cardViewHandler.filteredDeck.count != 0 && cardViewHandler.index < cardViewHandler.filteredDeck.count{
                    Text(cardViewHandler.filteredDeck[cardViewHandler.index].front)
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
            self.cardViewHandler.appBrain = self.appBrain
            cardViewHandler.handleFilteringForDueCards()
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
                        self.cardViewHandler.handleGood()
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
