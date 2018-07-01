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

struct UserRequest {
    var action: String
    var arguments: [String]
}

class Game: RoomDelegate {
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

        let exit = Exit(direction: .NorthEast, target: room2)
        room.exits.append(exit)

        self.player.room = room

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

        processRequest(request)
    }

    private func tokenizeInput(_ input: String) -> UserRequest? {
        var tokens = input.lowercased().split(separator: " ")

        // We can't allow empty commands
        if tokens.isEmpty {
            return nil
        }

        let action = tokens.removeFirst()
        let request = UserRequest(action: String(action), arguments: tokens.map { String($0) })

        return request
    }

    private func processRequest(_ request: UserRequest) {
        // Process game-wide actions
        switch request.action {
        case "quit":
            self.State = .Exiting
        default:
            display("Invalid Command: \(request.action)")
        }
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
}
