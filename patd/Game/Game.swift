//
//  Game.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation
import Cocoa

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
    var command: String
}

class Game: RoomDelegate {
    var delegate: GameProtocol?
    var player: Player
    var intents: [Intent] = []

    private(set) var rooms: [Room] = []
    private var moves: Int = 0
    private var displayBuffer: String = ""

    var State: GameState = .NotRunning {
        didSet {
            self.stateExited(oldValue)
            self.stateEntered(self.State)
        }
    }

    var currentRoom: Room {
        return self.player.room
    }

    static let shared = Game()

    init() {
        Logger.debug("Game loading")
        
        // FIXME: Fix this silly requirement
        let tmpRoom = Room()
        self.player = Player(room: tmpRoom)

        self.add(intent: QuitGameIntent())
        self.add(intent: HelpIntent())
        self.add(intent: IntentsIntent())

        Logger.debug("Game instatiated")
    }
    
    func room(withID id: GameObjectID) -> Room? {
        for room in rooms {
            if room.Id == id {
                return room
            }
        }
        
        return nil
    }

    func display(_ message: String) {
        let combined = displayBuffer + message

        print(combined)
        self.displayBuffer = ""
    }

    func display(_ message: String, noReturn: Bool) {
        if noReturn {
            self.displayBuffer.append(message)
        } else {
            Game.shared.display(message)
        }
    }

    func registerIntent(_ intent: Intent) {
        self.intents.append(intent)
    }

    func createRoom(name: String, description: String, exits: [Exit], items: [Item]) -> Room {
        let room = Room()

        room.name = name
        room.description = description
        room.delegate = self
        self.rooms.append(room)

        return room
    }

    func run() {
        self.State = .Running
    }

    func render() {
        // Render the current room

        self.currentRoom.render()
    }

    // MARK: Player Input
    func handlePlayerInput(_ input: String) {
        Logger.debug("Processing player input - > ", input)

        guard let request = tokenizeInput(input) else { return }


        guard let intent = processRequest(request) else {
            Game.shared.display("Invalid command")

            return
        }

        if intent.execute() {
            // command resulted in it's intended action
            Logger.debug("Command achieved it's goal")
        } else {
            // command failed for some reason, benign or not
            Logger.debug("Command exited early for some reason or another.")
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

    func allIntentsAndPurposes() -> [Intent] {
        return [self.intents, self.player.intents, self.currentRoom.intents].flatMap { $0 }
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
        for intent in self.player.intents {
            if intent.triggers.contains(request.command) {
                return intent
            }
        }

        for intent in Game.shared.currentRoom.intents {
            if intent.triggers.contains(request.command) {
                return intent
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
    func add(room: Room) {
        self.rooms.append(room)
    }
    
    func room(entered room: Room) {
        Logger.debug("Entered room: ", room.name)
        
        self.moves = self.moves + 1

        self.delegate?.game(playerDidEnterRoom: room)
    }

    func room(exited room: Room) {
        Logger.debug("Exited room: ", room.name)

        self.delegate?.game(playerDidExitRoom: room)
    }

    private func add(intent: Intent) {
        self.intents.append(intent)
    }
}
