//
//  EditCardsViewCard.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import SwiftUI

struct EditCardsViewCard: View {
    
    @EnvironmentObject var appBrain: AppBrain
    @StateObject var editCardsViewHandler: EditCardsViewHandler = EditCardsViewHandler()
    
    let card: Card
        
    init(card: Card) {
        self.card = card
    }
    
    var body: some View{
        
            HStack{
                VStack(alignment: .leading){
                    Text(card.front)
                    Text(card.back)
                }
                Spacer()
                Button {
                    editCardsViewHandler.handleIsEditCardClicked(front: card.front, back: card.back, id: card.id)
                } label: {
                    Image(systemName: "pencil")
                }
                Button {
                    editCardsViewHandler.handleIsDeleteCardAlertClicked(id: card.id)
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
            .alert("Edit Card", isPresented: self.$editCardsViewHandler.isEditCardAlertShown, actions: {
                TextField("Front", text: self.$editCardsViewHandler.front)
                    .autocorrectionDisabled(true)
                TextField("Back", text: self.$editCardsViewHandler.back)
                    .autocorrectionDisabled(true)
                Button("Save Changes", action: {
                    editCardsViewHandler.handleEditCard()
                })
                Button("Cancel", role: .cancel, action: {
                    editCardsViewHandler.handleCancel()
                })
            }, message: {
                Text("Provide Details.")
            })
            .alert("Do you want to delete this card?", isPresented: self.$editCardsViewHandler.isDeleteCardAlertShown, actions: {
                Button("Yes, delete", action: {
                    editCardsViewHandler.handleDeleteCard()
                })
                Button("Cancel", role: .cancel, action: {
                    editCardsViewHandler.handleCancel()
                })
            }, message: {
                //Text("Are you sure?")
            })
            .onAppear{
                self.editCardsViewHandler.appBrain = self.appBrain
            }
        
    }

}
