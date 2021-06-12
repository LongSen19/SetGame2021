//
//  SetGame.swift
//  SetGame2021
//
//  Created by Long Sen on 6/10/21.
//

import Foundation

struct SetEngine {
    
    var deck: [Card]
    var cardsOnBoard: [Card]
    var cardIndex: Int
    var selectedCards: [Card] {
        didSet {
            print(selectedCards.count)
            if selectedCards.count == 3 {
                if checkMatched(of: selectedCards) {
                    removeMatchedCards(cards: selectedCards)
                }
            }
        }
    }
    
    init() {
        deck = []
        cardsOnBoard = []
        cardIndex = 0
        selectedCards = []
    }
    
    
    mutating func drawCards() {
        if cardIndex < 80 {
            let numOfCards = (cardIndex > 0) ? 3 : 12
            for _ in 0..<numOfCards {
                cardsOnBoard.append(deck[cardIndex])
                cardIndex += 1
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        if !selectedCards.contains(where: { $0.id == card.id }) {
            selectedCards.append(card)
        }
    }
    
    func checkMatched(of cards: [Card]) -> Bool {
        let shadingSet = Set(cards.map({$0.shading}))
        let symbolSet = Set(cards.map({$0.symbol}))
        let colorSet = Set(cards.map({$0.color}))
        let quantitySet = Set(cards.map({$0.quantity}))
        let result = [shadingSet.count, symbolSet.count, colorSet.count, quantitySet.count].filter({$0 == 1})
        return result.count == 3
    }
    
    mutating func removeMatchedCards(cards: [Card]) {
        var setOfOnBoard = Set(cardsOnBoard)
        var setCards = Set(cards)
        print(setOfOnBoard.count, setCards.count)
        setOfOnBoard.subtract(setCards)
        print(setOfOnBoard.count)
        print(setOfOnBoard)
        
    }
    
    mutating func setUpDeck() {
        for shade in Card.Shade.allCases {
            for symbol in Card.Symbol.allCases {
                for color in Card.Color.allCases {
                    for quantity in Card.Quantity.allCases {
                        deck.append(Card(shading: shade, symbol: symbol, color: color, quantity: quantity))
                    }
                }
            }
        }
    }
    
    mutating func startGame() {
        setUpDeck()
        drawCards()
    }
    
    
    struct Card: Identifiable, Hashable {
        let id = UUID()
        let shading: Shade
        let symbol: Symbol
        let color: Color
        let quantity: Quantity
        
        
        enum Shade: String {
            case solid
            case open
            case stripped
            static let allCases: [Shade] = [.solid, .open, .stripped]
            
        }
        
        enum Symbol: String {
            case diamond
            case triangle
            case roundedRectangle
            static let allCases: [Symbol] = [.diamond, .triangle, .roundedRectangle]
        }
        
        enum Color: String {
            case red
            case green
            case blue
            static let allCases: [Color] = [.red, .blue, .green]
        }
        
        enum Quantity: Int {
            case one = 1
            case two
            case three
            static let allCases: [Quantity] = [.one, .two, three]
        }
    }
    
}
