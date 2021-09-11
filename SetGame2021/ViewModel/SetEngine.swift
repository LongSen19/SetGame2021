//
//  SetGame.swift
//  SetGame2021
//
//  Created by Long Sen on 6/10/21.
//

import Foundation

struct SetEngine {
    
    var deck: [Card] = []
    var cardsOnBoard: [Card] = []
    var cardIndex: Int = 0
    var matchedCards: [Card] = []
    var discardCards: [Card] = []
    var selectedCards: [Card] {
        willSet {
            if selectedCards.count == 0 {
                cardsOnBoard.indices.forEach({cardsOnBoard[$0].status = .neutral})
            }
        }
        didSet {
            if selectedCards.count == 3 {
                cardsOnBoard.indices.forEach({cardsOnBoard[$0].isSelected = false})
                if checkMatched(of: selectedCards) {
                    setCardsStatus(cards: selectedCards, status: .matched)
                    matchedCards = selectedCards
                } else {
                    setCardsStatus(cards: selectedCards, status: .misMatched)
                }
                selectedCards.removeAll()
            }
        }
    }
    
    init() {
        selectedCards = []
        
    }
    
    
    mutating func drawCards() {
        let numOfCards = deck.count == Constant.numOfCardIndeck ? Constant.initialCards : Constant.dealCards
        if deck.count != 0 {
            for _ in 0..<numOfCards {
                var card = deck.first
                card!.isFlipped = true
                cardsOnBoard.append(card!)
                deck.remove(at: 0)
            }
        }
    }
    
    mutating func dealCards() {
        cardsOnBoard.indices.forEach({cardsOnBoard[$0].status = .neutral})
        drawCards()
    }
    
    mutating func choose(_ card: Card) {
        let index = cardsOnBoard.firstIndex(where: {$0.id == card.id})
        if !selectedCards.contains(where: { $0.id == card.id }) {
            cardsOnBoard[index!].isSelected = true
            selectedCards.append(card)
        } else {
            selectedCards.removeAll(where: {$0.id == card.id})
            cardsOnBoard[index!].isSelected = false
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
    
    
    mutating func removeMatchedCards() {
        for card in matchedCards {
            cardsOnBoard = cardsOnBoard.filter({$0.id != card.id})
            discardCards.append(card)
        }
        matchedCards = []
    }
    
    
    mutating func setCardsStatus(cards: [Card], status: Card.Status) {
        for card in cards {
            if let index = cardsOnBoard.firstIndex(where: {$0.id == card.id}) {
                cardsOnBoard[index].status = status
            }
        }
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
    
    mutating func newGame() {
        deck = []
        cardsOnBoard = []
        cardIndex = 0
        selectedCards = []
        matchedCards = []
        discardCards = []
        setUpDeck()
    }
    
    struct Constant {
        static let initialCards = 12
        static let numOfCardIndeck = 81
        static let dealCards = 3
    }
    
    
    struct Card: Identifiable {
        let id = UUID()
        let shading: Shade
        let symbol: Symbol
        let color: Color
        let quantity: Quantity
        var isSelected = false
        var status: Status = .neutral
        var isFlipped = false
        
        
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
            case organe
            case purple
            case blue
            static let allCases: [Color] = [.organe, .blue, .purple]
        }
        
        enum Quantity: Int {
            case one = 1
            case two
            case three
            static let allCases: [Quantity] = [.one, .two, three]
        }
        
        enum Status: String {
            case matched
            case misMatched
            case neutral
            static let allCases: [Status] = [.matched, .misMatched, neutral]
        }
    }
    
}
