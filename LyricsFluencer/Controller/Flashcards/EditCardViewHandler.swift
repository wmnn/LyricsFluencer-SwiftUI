//
//  EditCardView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import FirebaseFirestore


class EditCardsViewHandler: ObservableObject {
  
    var cardContext: CardContext!
    @Published var isEditCardAlertShown: Bool = false
    @Published var isDeleteCardAlertShown: Bool = false
    
    func handleIsEditCardClicked(_ card: Card) {
        self.cardContext.selectedCard = card;
        self.cardContext.tmpCard = Card(card)
        self.isEditCardAlertShown = true
    }

    func handleIsDeleteCardAlertClicked(_ card: Card){
        self.cardContext.selectedCard = card;
        self.cardContext.tmpCard = Card(card)
        self.isDeleteCardAlertShown = true
    }
    
    func handleCancel(){
        self.isEditCardAlertShown = false
        self.isDeleteCardAlertShown = false
        self.cardContext.selectedCard = nil;
    }
    
    func handleEdit() {
        cardContext.editCard() { updatedCard in
            guard updatedCard != nil else {
                return;
            }
            self.isEditCardAlertShown = false
            self.cardContext.selectedCard = nil;
        }
    }
    
    func handleDelete() {
        cardContext.deleteCard { isDeleted in
            guard isDeleted == true else {
                return;
            }
            DispatchQueue.main.async {
                self.isDeleteCardAlertShown = false
                self.cardContext.selectedCard = nil;
            }
        }
    }
}
