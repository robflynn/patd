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
    var inventory: Inventory = Inventory()

    private var intents: [Intent] = []
    
    internal var room: Room?

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

        return false
    }

    // MARK: Inventory
    func add(toInventory item: Item) {
        inventory.add(item)
    }

    func remove(fromInventory item: Item) -> Item? {
        return inventory.remove(item)
    }

    func isCarrying(item: Item) -> Bool {
        return self.inventory.contains(item)
    }

    // MARK: Intents
    func registeredIntents() -> [Intent] {
        var tmp: [[Intent]] = []

        tmp.append(self.intents)

        for item in self.inventory.items {
            Logger.debug(" -> \(item.name)")

            tmp.append(item.intents)
        }

        return tmp.flatMap{ $0 }
    }

    func add(intent: Intent) {
        self.intents.append(intent)
    }
}
