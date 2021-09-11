//
//  ViewExtension.swift
//  SetGame2021
//
//  Created by Long Sen on 9/3/21.
//

import SwiftUI

extension View {
    func getColor(card: Card) -> Color {
        switch card.color {
        case .blue: return Color.blue
        case .organe: return Color.orange
        case .purple: return Color.purple
        }
    }
}
