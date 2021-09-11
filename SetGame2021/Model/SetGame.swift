//
//  SetGame.swift
//  SetGame2021
//
//  Created by Long Sen on 6/10/21.
//

import Foundation

class SetGame: ObservableObject {
    
    @Published private var model = SetEngine()
    
    init() {
        model.setUpDeck()
    }
    
    var deck: [Card] {
        model.deck
    }
    
    var cardsOnBoard: [Card] {
        model.cardsOnBoard
    }
    
    var discardCards: [Card] {
        model.discardCards
    }
    
    var setFound: Int {
        discardCards.count / 3
    }
    
    
    //MARK: - Intent
    func dealCards() {
        model.dealCards()
    }
    
    func removeMathedCards() {
        model.removeMatchedCards()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        model.newGame()
    }
}
