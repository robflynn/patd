//
//  Character.swift
//  patd
//
//  Created by Rob Flynn on 7/6/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Character: GameObject {
    var name: String
    var inventory: [Item] {
        return self._inventory
    }

    internal var _inventory: [Item] = []
    internal(set) var room: Room?

    init(name: String) {
        self.name = name

        super.init()
    }

    // MARK: Movement
    // Move the character to the specified room
    func moveTo(room: Room) -> Bool {

        if let currentRoom = self.room {
            currentRoom.remove(character: self)
        }

        return self.moveTo(room: room)
    }

    // MARK: Inventory
    func add(toInventory item: Item) {
        self._inventory.append(item)
    }

    func remove(fromInventory item: Item) -> Item? {
        if let index = self._inventory.index(of: item) {
            self._inventory.remove(at: index)

            return item
        }

        return nil
    }

    func isCarrying(item: Item) -> Bool {
        return self.inventory.contains(item)
    }
}
