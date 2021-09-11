//
//  Cardify.swift
//  SetGame2021
//
//  Created by Long Sen on 6/17/21.
//

import SwiftUI

struct Cardify: ViewModifier {
    var card: Card
    var size: CGSize
    
    init(of card: Card, in size: CGSize) {
        self.card = card
        self.size = size
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.height/10)
                .foregroundColor(card.status == .neutral ? getColor().opacity(0.3) : (card.status == .matched ? Color.green : Color.red))
            if card.isSelected {
            RoundedRectangle(cornerRadius: size.height/10)
                .stroke(lineWidth: 3.0)
                .foregroundColor(.blue)
            }
            content
            if !card.isFlipped {
                RoundedRectangle(cornerRadius: size.height/10)
                    .foregroundColor(Color.pink)
            }
        }
        .background(RoundedRectangle(cornerRadius: size.height/10).foregroundColor(.black))
        }
    
    func getColor() -> Color {
        switch card.color {
        case .blue: return Color.blue
        case .organe: return Color.orange
        case .purple: return Color.purple
        }
    }
}

extension View {
    func cardify(of card: Card, in size: CGSize) -> some View {
        self.modifier(Cardify(of: card, in: size))
    }
}
