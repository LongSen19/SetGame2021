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
        drawCardView()
    }
    
    func drawCardView() -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .opacity(0.7)
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(lineWidth: 3.0)
//                .foregroundColor(.blue)
            VStack {
                ForEach(0..<card.quantity.rawValue) { _ in
                    drawSymbolAndShading()
                }
            }
        }
    }
    
    func drawSymbolAndShading() -> some View {
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
    }
    
    func getColor() -> Color {
        switch card.color {
        case .blue: return Color.blue
        case .green: return Color.green
        case .red: return Color.red
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
    
//    func roundedRectangle(in rect: CGRect) -> Path {
//
//        var p = Path()
//        p.move(to: CGPoint(x: rect.maxX/4, y: rect.midY - rect.midY/8))
//        p.addLine(to: CGPoint(x: rect.maxX - rect.maxX/4, y: rect.midY - rect.midY/8))
//        p.move(to: CGPoint(x: rect.maxX/4, y: rect.midY + rect.midY/8))
//        p.addLine(to: CGPoint(x: rect.maxX - rect.maxX/4, y: rect.midY + rect.midY/8))
//        p.addArc(center: CGPoint(x: rect.maxX/4, y: rect.midY), radius: rect.midY/8, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)
//        p.addArc(center: CGPoint(x: rect.maxX - rect.maxX/4, y: rect.midY), radius: rect.midY/8, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: false)
//
//        return p
//
//    }
    
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
        let card = Card(shading: .stripped, symbol: .roundedRectangle, color: .blue, quantity: .one)
        CardView(card)
    }
}
