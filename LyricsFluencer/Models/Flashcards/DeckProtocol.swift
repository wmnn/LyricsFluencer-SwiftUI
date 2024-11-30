//
//  DeckProtocol.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 30.11.24.
//
protocol DeckProtocol {
    
    func createDeck(deckName: String, completion: @escaping (Deck) -> Void)
    func fetchingDecks(completion: @escaping ([Deck]?) -> Void)
    func handleAddToDeck(front: String, back: String, deckName: String, completion: @escaping (Card?) -> Void) 
    func handleDeleteDeck(deckName: String, completion: @escaping (String) -> Void)
    
}
