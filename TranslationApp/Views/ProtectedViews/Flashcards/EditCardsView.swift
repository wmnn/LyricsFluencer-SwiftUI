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
                ForEach(appBrain.selectedDeck.cards ?? []) { card in
                    HStack{
                        VStack(alignment: .leading){
                            Text(card.front)
                            Text(card.back)
                        }
                        Spacer()
                        Button {
                            editCardViewHandler.handleIsEditCardClicked(front: card.front, back: card.back, id: card.id)
                        } label: {
                            Image(systemName: "pencil")
                        }
                        Button {
                            editCardViewHandler.handleIsDeleteCardAlertClicked(id: card.id)
                        } label: {
                            Image(systemName: "trash")
                        }   
                    }
                    .bold()
                    .font(.system(size: 18))
                    .frame(width: 300, height: 20, alignment: .center)
                    .foregroundColor(Color("textColor"))
                    .padding()
                    .background {
                        Color("primaryColor")
                    }
                    .cornerRadius(18)
                }
            }
        }
        .navigationTitle(appBrain.selectedDeck.deckName)
        .alert("Edit Card", isPresented: $editCardViewHandler.isEditCardAlertShown, actions: {
            TextField("Front", text: self.$editCardViewHandler.front)
                .autocorrectionDisabled(true)
            TextField("Back", text: self.$editCardViewHandler.back)
                .autocorrectionDisabled(true)
            Button("Save Changes", action: {
                editCardViewHandler.handleEditCard(appBrain: appBrain)
            })
            Button("Cancel", role: .cancel, action: {
                editCardViewHandler.handleCancel()
            })
        }, message: {
            Text("Provide Details.")
        })
        .alert("Do you want to delete this card?", isPresented: $editCardViewHandler.isDeleteCardAlertShown, actions: {
            Button("Yes, delete", action: {
                editCardViewHandler.handleDeleteCard(appBrain: appBrain)
            })
            Button("Cancel", role: .cancel, action: {
                editCardViewHandler.handleCancel()
            })
        }, message: {
            //Text("Are you sure?")
        })
    }
}

struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
