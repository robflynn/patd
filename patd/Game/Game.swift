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

        let wohouse = self.createRoom(name: "West of House", description: "This is an open field west of a white house, with a boarded front door.", exits: [], items: [])

        wohouse.add(item: Mailbox())

        let mat = Item(name: "mat", description: "Welcome to Zork!", properties: [.Renderable])
        mat.renderText = "A rubber mat saying 'Welcome to Zork!' lies by the door."
        wohouse.add(item: mat)

        player.room = wohouse

        let forest1 = self.createRoom(name: "Forest", description: "This is a forest, with trees in all directions around you", exits: [], items: [])

        let exit = Exit(direction: .West, target: forest1)
        wohouse.add(exit: exit, mutual: true)


        Logger.debug("Game instatiated")
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
                let item = openIntent.item
                
                item.open()
            }
        case .CloseItem:
            if let closeIntent = intent as? CloseItemIntent {
                if closeIntent.item.isOpenable {
                    closeIntent.item.isOpen = false

                    display("You close the \(closeIntent.item.name)")
                } else {
                    display("You cannot close the \(closeIntent.item.name).")
                }
            }
        case .Inventory:
            showInventory()
        case .ExamineRoom:
            self.player.room?.render()
        case .LookInsideItem:
            if let lookInsideIntent = intent as? LookInsideItemIntent {
                let item = lookInsideIntent.item
                
                // FIXME: For now we're just going to assume it's always a mailbox as I'm not sure how I want to structure this yet
                guard let mailbox = item as? Mailbox else { return }
                
                display(mailbox.internalDescription)
                
            }
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
