//
//  main.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

func display(_ message: String) {
    print(message)
}

func display(_ message: String, noReturn: Bool) {
    if noReturn {
        print(message, terminator: "")
    } else {
        display(message)
    }
}

class Patd: GameProtocol {
    let game = Game()

    var gameState: GameState {
        return self.game.State
    }

    init() {
        self.game.delegate = self
    }

    func getUserInput() -> String? {
        display("> ", noReturn: true)

        let input = readLine()

        return input
    }

    func run() {
        display("Hello World! You have entered the game. Where be ye, yo?")

        game.run()

        while gameState == .Running {
            game.render()

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

}

Patd().run()
