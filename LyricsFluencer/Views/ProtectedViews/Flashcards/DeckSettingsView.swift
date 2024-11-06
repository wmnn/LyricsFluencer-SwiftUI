//
//  DeckView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 24.02.23.
//

import SwiftUI

struct DeckSettingsView: View {
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var deckContext: DeckContext
    @StateObject var deckSettingsHandler = DeckSettingsHandler()
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                Button {
                    self.deckSettingsHandler.showCreateCardAlert = true
                } label: {
                    TextWithIcon(text: "Add Card", systemName: "plus")
                }
                Button {
                    appBrain.navigate(to: Views.EditCardsView)
                } label: {
                    TextWithIcon(text: "Edit Cards", systemName: "gearshape")
                }
                Button {
                    deckSettingsHandler.showDeleteDeckAlert.toggle()
                } label: {
                    TextWithIcon(text: "Delete Deck", systemName: "trash")
                }
            }
        }
        .navigationTitle(self.deckContext.selectedDeck.deckName)
        .alert("Create card", isPresented: $deckSettingsHandler.showCreateCardAlert, actions: {
            TextField("Front", text: self.$deckSettingsHandler.front)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            TextField("Back", text: self.$deckSettingsHandler.back)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            Button("Create Card", action: {
                deckSettingsHandler.handleCreateCard(deckContext: deckContext)
            })
            Button("Cancel", role: .cancel, action: {
                deckSettingsHandler.handleCancel()
            })
        }, message: {
            Text("Provide Details.")
        })
        .alert("Do you want to delete this deck?", isPresented: $deckSettingsHandler.showDeleteDeckAlert, actions: {
            Button("Yes, delete") {
                self.deckContext.handleDeleteDeck()
                self.appBrain.path.removeLast()
                
            }

            Button("Cancel", role: .cancel, action: {
                deckSettingsHandler.showDeleteDeckAlert.toggle()
            })
        }, message: {
            
        })
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckSettingsView()
    }
}
