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

class Room: GameObject, Container, ContainerDelegate {
    var name: String = "A Room"
    var description: String = "A nondescript room."

    var players: [Player] = []
    var delegate: RoomDelegate?
    var items: [Item] = []

    var escapes: [GameLoader.EscapeData] = []

    private var intents: [Intent] = []

    private(set) var exits: [Exit] = []

    override init() {
        super.init()

        self.add(intent: ExamineRoomIntent())
    }

    func examine() -> Bool {
        if let output = self.render() {
            Game.shared.display(output)

            return true
        }

        return false
    }

    func render() -> String? {
        self.buffer.clear()

        self.buffer.send(name)
        self.buffer.send(description)

        for item in items {
            if item.isDropped { continue }

            if let itemText = item.environmentalText {
                self.buffer.send(itemText)
            }
        }

        renderItems()
        renderExits()

        return self.buffer.flush()
    }

    private func renderItems() {
        let visibleItems = self.items.filter { $0.isGettable }.filter { $0.isDropped }

        if visibleItems.isEmpty { return }

        self.buffer.newLine()

        self.buffer.send("Items: \(visibleItems.listified()).")
    }

    private func renderExits() {
        if self.exits.isEmpty { return }

        buffer.newLine()

        buffer.send("Obvious exits are: ", noReturn: true)
        buffer.send(self.exits.map { $0.direction.Name }.joined(separator: ", "))
    }

    func addEscape(_ escape: GameLoader.EscapeData) {
        self.escapes.append(escape)

        self.add(intent: EscapeRoomIntent(escape: escape))
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

        self.add(intent: TakeExitIntent(with: exit))
    }

    func registeredIntents() -> [Intent] {
        var tmp: [[Intent]] = []

        tmp.append(self.intents)

        for item in self.items {
            tmp.append(item.registeredIntents())
        }

        return tmp.flatMap{ $0 }
    }
    
    // MARK: Container
    var interiorText: String {
        return description
    }

    func add(item: Item) {
        self.items.append(item)
    }

    func remove(item: Item) {
        if let index = self.items.index(of: item) {
            self.items.remove(at: index)
        }
    }

    func contains(item: Item) -> Bool {
        return self.items.contains(item)
    }

    private func add(intent: Intent) {
        self.intents.append(intent)
    }

    func container(didAcceptItem item: Item) {
    }

    func container(didRemoveItem item: Item) {
    }

    var isContainer: Bool {
        return true
    }
}
