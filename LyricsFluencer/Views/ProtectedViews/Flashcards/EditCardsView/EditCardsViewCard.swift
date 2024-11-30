//
//  EditCardsViewCard.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import SwiftUI

struct EditCardsViewCard: View {
    
    @EnvironmentObject var appBrain: AppContext
    @StateObject var editCardsViewHandler: EditCardsViewHandler = EditCardsViewHandler()
    @EnvironmentObject var cardContext: CardContext
    
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
                    editCardsViewHandler.handleIsEditCardClicked(card)
                } label: {
                    Image(systemName: "pencil")
                }
                Button {
                    editCardsViewHandler.handleIsDeleteCardAlertClicked(card)
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
                TextField("Front", text: self.$cardContext.tmpCard.front)
                    .autocorrectionDisabled(true)
                TextField("Back", text: self.$cardContext.tmpCard.back)
                    .autocorrectionDisabled(true)
                Button("Save Changes", action: {
                    editCardsViewHandler.handleEdit()
                })
                Button("Cancel", role: .cancel, action: {
                    editCardsViewHandler.handleCancel()
                })
            }, message: {
                Text("Provide Details.")
            })
            .alert("Do you want to delete this card?", isPresented: self.$editCardsViewHandler.isDeleteCardAlertShown, actions: {
                Button("Yes, delete", action: {
                    editCardsViewHandler.handleDelete()
                })
                Button("Cancel", role: .cancel, action: {
                    editCardsViewHandler.handleCancel()
                })
            }, message: {
                //Text("Are you sure?")
            })
            .onAppear{
                self.editCardsViewHandler.cardContext = self.cardContext
            }
        
    }

}
