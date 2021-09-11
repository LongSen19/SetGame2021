//
//  ContentView.swift
//  SetGame2021
//
//  Created by Long Sen on 6/10/21.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game: SetGame
    
    @Namespace private var cardNamespace
        
    @State private var dealt = Set<UUID>()
    
    @State private var startGame = true
    
    @State private var discardCards = Set<UUID>()

    
    // marks the given card as having been dealt
    private func deal(_ card: Card) {
        dealt.insert(card.id)
    }
    
    private func discard(_ card: Card) {
        discardCards.insert(card.id)
    }
    // returns whether the given card has not been dealt yet
    private func isUndealt(_ card: Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func isUnDiscard(_ card: Card) -> Bool {
        !discardCards.contains(card.id)
    }
    
    private func zIndex(of card: Card) -> Double {
        -Double(game.deck.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    // an Animation used to deal the cards out "not all at the same time"
    // the Animation is delayed depending on the index of the given card
    //  in our ViewModel's (and thus our Model's) cards array
    // the further the card is into that array, the more the animation is delayed
    private func dealAnimation(for card: Card) -> Animation {
        var delay = 0.0
        if var index = game.cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
            if game.deck.count < 69 {
                index = 3 - (game.cardsOnBoard.count - index)
            }
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cardsOnBoard.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func discardAnimation(for card: Card) -> Animation {
        let delay = 1.0
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            VStack{
                gameBody
                HStack {
                    deckBody
                    Spacer()
                    gameInfo
                    Spacer()
                    discardCardsView
                }
                .padding()
                .background(Color.gray.opacity(0.2))
            }
        }
    }
    
    var gameInfo: some View {
        VStack {
            Text("Remending Cards: \(game.deck.count)")
                .foregroundColor(.green)
            Text("Set Found: \(game.setFound)")
                .foregroundColor(.green)
            Button("New Game") {
                withAnimation {
                    game.newGame()
                }
            }
            .padding()
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cardsOnBoard, aspectRatio: 2/3,  minItemWidth: 70) { card in
            if !isUndealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
                    .padding(5)
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
    }
    
    
    var deckBody: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .background(Color.clear)
            ForEach(game.deck.filter(isUndealt)) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
                    .zIndex(zIndex(of: card))
            }
        }
        .padding(2)
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            withAnimation {
                game.removeMathedCards()
            }
            
            game.dealCards()
            for card in game.cardsOnBoard {
                if isUndealt(card) {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
            }
    }
    }
    
    
    var discardCardsView: some View {
        ZStack {
            ForEach(game.discardCards) { card in
               // if !isUnDiscard(card){
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
                    //.transition(AnyTransition.asymmetric(insertion: .slide, removal: .scale))
                    .zIndex(zIndex(of: card))
           // }
            }
        }
        .padding(2)
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        return SetGameView(game: game)
    }
}
