//
//  Room.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

protocol RoomDelegate {
    func room(entered room: Room)
    func room(exited room: Room)
}

class Room: GameObject {
    var name: String = "A Room"
    var description: String = "A nondescript room."

    var players: [Player] = []
    var delegate: RoomDelegate?
    var items: [Item] = []

    private var _intents: [Intent] = []

    var intents: [Intent] {
        Logger.debug("Generating intent list query")
        var tmp: [[Intent]] = []

        tmp.append(self._intents)

        for item in self.items {
            Logger.debug(" -> \(item.name)")
            tmp.append(item.intents)
        }

        return tmp.flatMap{ $0 }
    }

    private(set) var exits: [Exit] = []

    override init() {
        super.init()
    }

    func render() {
        display(name)
        display(description)
        renderItems()
        renderExits()
    }

    private func renderItems() {
        display("")
        if !self.items.isEmpty {
            display("Items:  \(self.items.map { $0.name }.joined(separator: ", "))")
        }
    }

    private func renderExits() {
        display("")

        if self.exits.isEmpty {
            display("There are no obvious exits.")

            return
        }

        display("Obvious exits are: ", noReturn: true)
        display(self.exits.map { $0.direction.Name }.joined(separator: ", "))
    }

    func add(item: Item) {
        self.items.append(item)
    }

    func remove(item: Item) {
        if let index = self.items.index(of: item) {
            Logger.debug(self.items.map { $0.Id })

            self.items.remove(at: index)

            Logger.debug(self.items.map { $0.Id })
        }
    }

    func contains(item: Item) -> Bool {
        return self.items.contains(item)
    }

    func add(player: Player) {
        // Player is already in the room, they can't be in it twice
        if self.players.contains(player) {
            return
        }

        self.players.append(player)

        self.delegate?.room(entered: self)
    }

    func remove(player: Player) {
        if let index = self.players.index(of: player) {

            self.players.remove(at: index)

            self.delegate?.room(exited: self)
        }
    }

    func add(exit: Exit) {
        self.exits.append(exit)

        let intent = TakeExitIntent(with: exit)
        self.addIntent(intent)
    }

    func add(exit: Exit, mutual: Bool) {
        self.add(exit: exit)

        if (mutual) {
            let returnExit = Exit(direction: exit.direction.Opposite, target: self)
            
            exit.target.add(exit: returnExit)
        }
    }

    private func addIntent(_ intent: Intent) {
        _intents.append(intent)
    }
}
