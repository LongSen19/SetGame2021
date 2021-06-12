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
        model.startGame()
    }
    
    var deck: [Card] {
        model.deck
    }
    
    var cardsOnBoard: [Card] {
        model.cardsOnBoard
    }
    
    
    //MARK: - Intent
    func dealCards() {
        model.drawCards()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}
