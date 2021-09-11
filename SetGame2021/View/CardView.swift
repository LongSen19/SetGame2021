//
//  CardView.swift
//  SetGame2021
//
//  Created by Long Sen on 6/10/21.
//

import SwiftUI

typealias Card = SetEngine.Card

struct CardView: View {
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            drawCardView(in: geometry.size)
            .rotationEffect(Angle.degrees(card.status == .misMatched ? 180 : 0))
            .cardify(of: card, in: geometry.size)
    }
    }
    
    func drawCardView(in size: CGSize) -> some View {
        ZStack{
            VStack {
                ForEach(0..<numberOfShapes(), id:\.self) { _ in
                    drawSymbolAndShading(in: size)
                        .rotationEffect(Angle.degrees(card.status == .matched ? 5*360 : 0))
                }
            }
            .rotationEffect(Angle.degrees(card.status == .matched ? 5*360 : 0))
        }
    }
    
    func numberOfShapes() -> Int {
        return card.quantity.rawValue
    }
    
    func drawSymbolAndShading(in asize: CGSize) -> some View {
        VStack{
            switch card.shading {
            case .open:
                Symbol(card.symbol)
                    .stroke(getColor())
            case .solid:
                Symbol(card.symbol)
                    .fill(getColor())
            case .stripped:
                Stripped()
                    .stroke(getColor())
                    .clipShape(Symbol(card.symbol))
            }
            
        }
        .padding(5)
        .frame(maxHeight: asize.height/4)
        .aspectRatio(3, contentMode: .fit)
    }
    
    func getColor() -> Color {
        switch card.color {
        case .blue: return Color.blue
        case .organe: return Color.orange
        case .purple: return Color.purple
        }
    }
}


struct Symbol: Shape {
    let symbol: Card.Symbol
    
    init(_ symbol: Card.Symbol) {
        self.symbol = symbol
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        switch symbol {
        
        case .diamond:
            p = diamond(in: rect)
        case .triangle:
            p = triangle(in: rect)
        case .roundedRectangle:
            p = roundedRectangle(in: rect)
        }
        
        return p
    }
    
    func triangle(in rect: CGRect) -> Path {
        
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return p
    }
    
    func diamond(in rect: CGRect) -> Path {
        
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.closeSubpath()
        return p
        
    }
    
    func roundedRectangle(in rect: CGRect) -> Path {
        var p = Path()
        p.addRoundedRect(in: CGRect(x: rect.minX, y: rect.maxY/4, width: rect.maxX, height: rect.maxY/2), cornerSize: CGSize(width: rect.maxX/5, height: rect.maxY/2))
        return p
    }
}


struct Stripped: Shape {
    func path(in rect: CGRect) -> Path {
        
        var p = Path()
        var currentStripOrigin = CGPoint(x: rect.minX, y: rect.minY)
        while rect.contains(currentStripOrigin) {
            p.move(to: currentStripOrigin)
            
            p.addLine(to: CGPoint(x: currentStripOrigin.x, y: rect.maxY))
            currentStripOrigin.x += 4
            // p.move(to: currentStripOrigin)
        }
        return p
    }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = Card(shading: .solid, symbol: .roundedRectangle, color: .blue, quantity: .two)
        CardView(card)
    }
}
