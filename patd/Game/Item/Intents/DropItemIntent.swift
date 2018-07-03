//
//  DropItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class DropItemIntent: Intent {
    var intentType: IntentType {
        return .DropItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["drop"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) the \(item.name.lowercased())")
        }

        self.item = item
    }

    func execute() -> Bool {
        if !Game.shared.player.isCarrying(item: item) {
            Game.shared.display("You are not carrying that.")
            return false
        }

        Game.shared.player.remove(fromInventory: item)
        Game.shared.currentRoom.add(item: item)

        return true
    }
}
