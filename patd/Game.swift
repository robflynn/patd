//
//  Game.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

enum GameState {
    case NotRunning
    case Running
}

protocol GameProtocol {
    func game(exitedState state: GameState)
    func game(enteredState state: GameState)
}

class Game {
    var delegate: GameProtocol?
    var player: Player

    private var rooms: [Room] = []

    var State: GameState = .NotRunning {
        didSet {
            self.stateExited(oldValue)
            self.stateEntered(self.State)
        }
    }

    init() {
        Logger.debug("Game loading")

        let room = Room()
        rooms.append(room)

        // Spawn the player
        self.player = Player(room: room)

        Logger.debug("Game instatiated")
    }

    func run() {
        self.State = .Running
    }

    func render() {
        // Render the current room
        self.player.room.render()
    }

    // MARK: Player Input
    func executePlayerInput(_ input: String) {
        Logger.debug("Processing player input - > ", input)
    }

    // MARK: GameState Changes
    private func stateExited(_ state: GameState) {
        Logger.debug("Exited State -> ", state)

        self.delegate?.game(exitedState: state)
    }

    private func stateEntered(_ state: GameState) {
        Logger.debug("Entered State -> ", state)

        self.delegate?.game(enteredState: state)
    }
}
