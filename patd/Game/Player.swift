//
//  Player.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Player: GameObject {
    var room: Room {
        didSet {
            oldValue.remove(player: self)
            room.add(player: self)
        }
    }

    private var _inventory: [Item] = []
    
    var inventory: [Item] {
        return self._inventory
    }

    private var intents: [Intent] = []

    init(room: Room) {
        self.room = room

        self.intents.append(InventoryIntent())
        
        super.init()
    }

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

    func registeredIntents() -> [Intent] {
        var tmp: [[Intent]] = []

        tmp.append(self.intents)

        for item in self._inventory {
            Logger.debug(" -> \(item.name)")

            tmp.append(item.intents)
        }

        return tmp.flatMap{ $0 }
    }
}
