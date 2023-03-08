//
//  DeckView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 24.02.23.
//

import SwiftUI

struct DeckSettingsView: View {
    @EnvironmentObject var appBrain: AppBrain
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
                    appBrain.path.append("EditCardsView")
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
        .navigationTitle(appBrain.selectedDeck.deckName)
        .onAppear{
            self.deckSettingsHandler.appBrain = self.appBrain
        }
        .alert("Create card", isPresented: $deckSettingsHandler.showCreateCardAlert, actions: {
            TextField("Front", text: self.$deckSettingsHandler.front)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            TextField("Back", text: self.$deckSettingsHandler.back)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            Button("Create Card", action: {
                deckSettingsHandler.handleCreateCard()
            })
            Button("Cancel", role: .cancel, action: {
                deckSettingsHandler.handleCancel()
            })
        }, message: {
            Text("Provide Details.")
        })
        .alert("Do you want to delete this deck?", isPresented: $deckSettingsHandler.showDeleteDeckAlert, actions: {
            Button("Yes, delete", action: {
                deckSettingsHandler.handleDeleteDeck()
            })
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
