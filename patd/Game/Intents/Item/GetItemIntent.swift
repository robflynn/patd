//
//  GetItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

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

        if let hoobs = hooble {
            if hoobs() {
                return true
            }
        }

        if !item.isGettable {
            Game.shared.display("You cannot get \(item.nameWithArticle()).")
            return false
        }

        // Is the item in the current room?
        if Game.shared.currentRoom.contains(item: item) {
            // Get the item
            Game.shared.currentRoom.remove(item: item)
            Game.shared.player.add(toInventory: item)

            Game.shared.display("You get \(item.nameWithArticle()).")

            return true
        }

        // If we see this message that means there's a gettable in
        // the intent scope and it shouldn't be
        Game.shared.display("What \(item.name)?")
        Logger.error("WOAAAH BUDDY WHAT HAPPENED?")

        return false
    }

    public var hooble: (() -> Bool)?
}
