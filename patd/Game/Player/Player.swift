//
//  Player.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Player: GameObject {
    var room: Room? {
        didSet {
            if let oldRoom = oldValue {
                oldRoom.remove(player: self)
            }

            if let newRoom = self.room {
                newRoom.add(player: self)
            }
        }
    }

    private var _inventory: [Item] = []
    
    var inventory: [Item] {
        return self._inventory
    }

    var intents: [Intent] {
        var tmp: [[Intent]] = []

        tmp.append(self._intents)

        for item in self._inventory {
            Logger.debug(" -> \(item.name)")
            tmp.append(item.intents)
        }

        return tmp.flatMap{ $0 }
    }

    private var _intents: [Intent] = []

    override init() {
        super.init()

        self._intents.append(InventoryIntent())
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
}
