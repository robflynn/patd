//
//  Player.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class InventoryIntent: Intent {
    var intentType: IntentType  {
        return .Inventory
    }

    var triggers: [String] = []

    init() {
        triggers.append("inventory")
        triggers.append("inv")
        triggers.append("i")
    }
}

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

    var inventory: [Item] = []
    var intents: [Intent] = []

    override init() {
        super.init()

        self.intents.append(InventoryIntent())
    }
}
