//
//  ContentView.swift
//  SetGame2021
//
//  Created by Long Sen on 6/10/21.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game: SetGame
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.gray)
                .ignoresSafeArea()
            VStack{
                AspectVGrid(items: game.cardsOnBoard, aspectRatio: 3/4) { card in
                    CardView(card)
                       .padding(5)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
                
                Button(action: {
                    game.dealCards()
                }, label: {
                    Text("Deal")
                })
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        return SetGameView(game: game)
    }
}
