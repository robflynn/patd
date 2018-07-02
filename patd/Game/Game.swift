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
    case TakeExit
    case QuitGame
    case GetItem
    case LookAtItem
    case DropItem
    case Inventory
    case ExamineRoom
    case OpenItem
}

// This intent system is going to be very basic for now
protocol Intent {
    var intentType: IntentType { get }
    var triggers: [String] { get }
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

        var map:String = """
{
    rooms: [
        {
            id: "room",
            name: "Room",
            description: "A nondescript room"
        }
    ]
}
"""

        // Spawn the player
        self.player = Player()

        self.addIntent(QuitGameIntent())

        let room = Room()
        room.name = "In Front of Cabin"
        room.description = "You are in front fo a cabin.\n\nThere is a mailbox here."
        room.delegate = self
        self.rooms.append(room)
        room.items.append(Item(name: "spoon", description: "a weird metal spoon", properties: [.Gettable]))
        room.items.append(Item(name: "mailbox", description: "a red wooden mailbox", properties: [.Openable]))

        player.room = room

        let room2 = Room()
        room2.name = "Next Room"
        room2.description = "This is a different room. There were no objects here."
        room2.delegate = self
        self.rooms.append(room2)

        room2.add(exit: Exit(direction: .South, target: room), mutual: true)

        Logger.debug("Game instatiated")
    }

    func run() {
        self.State = .Running
    }

    func render() {
        // Render the current room
        guard let room = self.player.room else {
            print("WHY IS ROOM NIL!?!?!?!?!")

            return
        }

        room.render()
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
        case .QuitGame:
            self.State = .Exiting
        case .TakeExit:
            if let exitIntent = intent as? TakeExitIntent {
                self.player.room = exitIntent.exit.target
            }
        case .LookAtItem:
            if let lookIntent = intent as? ExamineItemIntent {
                display(lookIntent.item.description)
            }
        case .GetItem:
            if let getIntent = intent as? GetItemIntent {

                if getIntent.item.isGettable {
                    display("You get \(getIntent.item.name)")

                    self.player.room?.remove(item: getIntent.item)
                    self.player.add(toInventory: getIntent.item)
                } else {
                    display("You cannot get the \(getIntent.item.name)")
                }
            }
        case .DropItem:
            if let dropIntent = intent as? DropItemIntent {
                if let item = self.player.remove(fromInventory: dropIntent.item) {
                    display("You drop \(dropIntent.item.name)")

                    self.player.room?.add(item: item)
                }
            }
        case .OpenItem:
            if let openIntent = intent as? OpenItemIntent {
                if openIntent.item.isOpenable {
                    openIntent.item.isOpen = true

                    display("You open the \(openIntent.item.name)")
                } else {
                    display("You cannot open the \(openIntent.item.name).")
                }
            }
        case .Inventory:
            showInventory()
        case .ExamineRoom:
            self.player.room?.render()
        default:
            Logger.error("Unhandled Intent: ", intent.intentType)
        }
    }

    private func showInventory() {
        if self.player.inventory.isEmpty {
            display("You are not carrying any items.")
        } else {
            display(self.player.inventory.map { $0.name }.joined(separator: ", "))
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
        for intent in self.player.intents {
            if intent.triggers.contains(request.command) {
                return intent
            }
        }

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
