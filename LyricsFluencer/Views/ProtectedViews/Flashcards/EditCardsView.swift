//
//  EditCardsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import SwiftUI

struct EditCardsView: View {
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var editCardViewHandler = EditCardsViewHandler()
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(appBrain.deckModel.selectedDeck.cards ?? []) { card in
                    EditCardsViewCard(card: card)
                }
            }
        }
        .navigationTitle(appBrain.deckModel.selectedDeck.deckName)
        .onAppear{
            self.editCardViewHandler.appBrain = self.appBrain
        }
    }
}

struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
