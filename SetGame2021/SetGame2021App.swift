//
//  SetGame2021App.swift
//  SetGame2021
//
//  Created by Long Sen on 6/10/21.
//

import SwiftUI

@main
struct SetGame2021App: App {
    private let game = SetGame()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
