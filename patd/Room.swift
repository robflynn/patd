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

struct Exit {
    var direction: Direction
    var target: Room
}

class Room: GameObject {
    var name: String = "A Room"
    var description: String = "A nondescript room."

    var players: [Player] = []
    var delegate: RoomDelegate?

    var exits: [Exit] = []

    override init() {
        super.init()
    }

    func render() {
        display(name)
        display(description)
        renderExits()
    }

    private func renderExits() {
        display("")

        if self.exits.isEmpty {
            display("There are no obvious exits.")

            return
        }

        display("Obvious exits are: ", noReturn: true)
        display(self.exits.map { $0.direction.Name }.joined(separator: ","))
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
        if !self.players.contains(player) {
            // The player is not in the room.
            return
        }

        // Remove
        let _ = self.players.filter { $0 == player }

        self.delegate?.room(exited: self)
    }
}
