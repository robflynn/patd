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
    case Exiting
}

protocol GameProtocol {
    func game(exitedState state: GameState)
    func game(enteredState state: GameState)

    func game(playerDidEnterRoom room: Room)
    func game(playerDidExitRoom room: Room)
}

enum IntentType {
    case takeExit
    case quitGame
}

// This intent system is going to be very basic for now
protocol Intent {
    var intentType: IntentType { get }
    var triggers: [String] { get }
}

// FIXME: Make a generic intent type, and change Intent procol's name to something else
class QuitGameIntent: Intent {
    var triggers: [String] = ["quit"]

    var intentType: IntentType {
        return .quitGame
    }
}

class TakeExitIntent: Intent {
    var intentType: IntentType {
        return .takeExit
    }

    var triggers: [String] = []
    private(set) var exit: Exit

    init(with exit: Exit) {
        // Add the direction as a trigger
        triggers.append(exit.direction.Name)

        // And all of the aliases
        for alias in exit.direction.Aliases {
            triggers.append(alias)
        }

        self.exit = exit
    }
}


struct UserRequest {
    var action: String
    var arguments: [String]
    var command: String
}

class Game: RoomDelegate {
    var delegate: GameProtocol?
    var player: Player
    var intents: [Intent] = []

    private var rooms: [Room] = []

    var State: GameState = .NotRunning {
        didSet {
            self.stateExited(oldValue)
            self.stateEntered(self.State)
        }
    }

    init() {
        Logger.debug("Game loading")
        // Spawn the player
        self.player = Player()

        let room = Room()
        room.delegate = self
        rooms.append(room)

        let room2 = Room()
        room2.name = "Another Room"
        room2.description = "This room is different but you're not sure how."
        room2.delegate = self
        rooms.append(room)

        let exit = Exit(direction: .North, target: room2)
        room.add(exit: exit)

        self.player.room = room

        self.addIntent(QuitGameIntent())

        Logger.debug("Game instatiated")
    }

    func run() {
        self.State = .Running
    }

    func render() {
        // Render the current room
        self.player.room?.render()
    }

    // MARK: Player Input
    func handlePlayerInput(_ input: String) {
        Logger.debug("Processing player input - > ", input)

        guard let request = tokenizeInput(input) else { return }


        guard let intent = processRequest(request) else {
            display("Invalid command")

            return
        }

        switch(intent.intentType) {
        case .quitGame:
            self.State = .Exiting
        case .takeExit:
            if let exitIntent = intent as? TakeExitIntent {
                self.player.room = exitIntent.exit.target
            }
        default:
            Logger.error("Unhandled Intent: ", intent.intentType)
        }
    }

    private func tokenizeInput(_ input: String) -> UserRequest? {
        var tokens = input.lowercased().split(separator: " ")

        // We can't allow empty commands
        if tokens.isEmpty {
            return nil
        }

        let action = tokens.removeFirst()
        let request = UserRequest(action: String(action), arguments: tokens.map { String($0) }, command: input.lowercased())

        return request
    }

    private func processRequest(_ request: UserRequest) -> Intent? {

        // Check our game's intents
        for intent in self.intents {
            if intent.triggers.contains(request.command) {
                return intent
            }
        }

        // Check the current room's intents
        // FIXME: we're going to need to rewrite this and allow objects to register their
        //        intents directly with the game itself via some kind of intent registration
        //        system.  This is because we'll eventually want items to be able to
        //        register intents and this func could get ridiculous
        if let room = self.player.room {
            for intent in room.intents {
                if intent.triggers.contains(request.command) {
                    return intent
                }
            }
        }

        return nil
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

    // MARK: Room
    func room(entered room: Room) {
        Logger.debug("Entered room: ", room.name)

        self.delegate?.game(playerDidEnterRoom: room)
    }

    func room(exited room: Room) {
        Logger.debug("Exited room: ", room.name)

        self.delegate?.game(playerDidExitRoom: room)
    }

    private func addIntent(_ intent: Intent) {
        intents.append(intent)
    }

}
