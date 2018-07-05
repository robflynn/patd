//
//  GetItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class GetItemIntent: Intent {
    var item: Item

    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        var triggers: [String] = []

        let actions = ["get", "pick up", "loot", "grab", "fetch"]

        for action in actions {
            triggers.append("\(action) \(item.name.lowercased())")
            triggers.append("\(action) \(item.nameWithArticle().lowercased())")
        }

        return triggers
    }

    override func execute() -> Bool {
        // Try to get the item
        guard self.item.get() != nil else {
            return false
        }

        // If we got the item, give it to the player
        Game.shared.player.add(toInventory: item)

        Game.shared.display("You get \(item.nameWithArticle()).")

        return true
    }
}
