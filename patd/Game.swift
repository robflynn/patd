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

    var State: GameState = .NotRunning {
        didSet {
            self.stateExited(oldValue)
            self.stateEntered(self.State)
        }
    }

    init() {
        Logger.debug("Game instatiated")
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
