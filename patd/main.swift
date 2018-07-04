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
        
        if !loadGameData() {
            // FIXME: Handle this
            print("There was an error reading the map data. Thing's are not going to work correctly.")
        }
    }
        
    func loadGameData() -> Bool {
        do {
            // FIXME: Couldn't find map file.  Handle This
            guard let mapJSON: String = try String(contentsOfFile: "map.json") else { return false }

            let loader = GameLoader()

            try loader.parse(jsonString: mapJSON)

            // Let's just drop the player in the first room if one exists
            if let firstRoom = Game.shared.rooms.first {
                Game.shared.player.room = firstRoom
            }
            
            return true
        } catch {
            print(error)
            return false
        }
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

    func render(message: String) {
        print(message)
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

    func game(gameDidUpdate message: String) {
        render(message: message)
    }
}

Patd().run()
