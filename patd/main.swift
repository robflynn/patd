//
//  main.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Patd: GameProtocol {
    let game = Game.shared

    var gameState: GameState {
        return self.game.State
    }

    init() {
        self.game.delegate = self
    }

    func getUserInput() -> String? {
        print("> ", terminator: "")

        let input = readLine()

        return input
    }

    func run() {
        game.run()

        game.render()
        while gameState == .Running {
            // Exit if we can't get input from the user, handle with proper exceptions later
            guard let input = self.getUserInput() else { return }

            game.handlePlayerInput(input)
        }
    }


    // MARK: GameProtocol
    func game(exitedState state: GameState) {
    }

    func game(enteredState state: GameState) {
    }

    func game(playerDidEnterRoom room: Room) {
        game.render()
    }

    func game(playerDidExitRoom room: Room) {
    }

}

Patd().run()
