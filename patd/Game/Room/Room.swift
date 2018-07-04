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
        self.buffer(name)
        self.buffer(description)

        for item in items {
            if item.isRenderable {
                // FIXME: We need to
                item.render()
            }
        }

        // FIXME: Render Items
        renderItems()

        // FIXME: Handle Exits
        renderExits()

        return self.flushBuffer()
    }

    private func renderItems() {
        // FIXME: Just because something is gettable doesn't mean it should be sitting on the ground, make some other indicator for this
        // FIXME: Maybe a "Dropped" state for an item, and if is dropped then it shows up in the item description. Yeah. I like that.
        // FIXME: Thanks for talking with me today, self.
        let visibleItems = self.items.filter { $0.isGettable }

        if visibleItems.isEmpty { return }

        self.buffer("")

        self.buffer("On the ground you see \(visibleItems.listified()).")
    }

    private func renderExits() {
        if self.exits.isEmpty { return }

        buffer("")

        buffer("Obvious exits are: ", noReturn: true)
        buffer(self.exits.map { $0.direction.Name }.joined(separator: ", "))
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
    var interiorDescription: String {
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
