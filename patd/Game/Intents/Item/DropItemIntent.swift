//
//  DropItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class DropItemIntent: Intent {
    var item: Item

    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        var triggers: [String] = []
        let actions = ["drop"]

        for action in actions {
            triggers.append("\(action) \(item.name.lowercased())")
            triggers.append("\(action) \(item.nameWithArticle().lowercased())")
        }

        return triggers
    }

    override func execute() -> Bool {
        if !Game.shared.player.isCarrying(item: item) {
            Game.shared.display("You are not carrying that.")
            return false
        }

        Game.shared.player.remove(fromInventory: item)
        item.isDropped = true
        Game.shared.currentRoom.add(item: item)

        Game.shared.display("You drop \(item.nameWithArticle()).")

        return true
    }
}
