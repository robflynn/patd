//
//  GetItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class GetItemIntent: Intent {
    var intentType: IntentType {
        return .GetItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["get", "pick up", "loot", "grab", "fetch"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) the \(item.name.lowercased())")
        }

        self.item = item
    }

    func execute() -> Bool {

        if !item.isGettable {
            Game.shared.display("You cannot get \(item.named()).")
            return false
        }

        // Is the item in the current room?
        if Game.shared.currentRoom.contains(item: item) {
            // Get the item
            Game.shared.currentRoom.remove(item: item)
            Game.shared.player.add(toInventory: item)

            Game.shared.display("You get \(item.named())")

            return true
        }

        // If we see this message that means there's a gettable in
        // the intent scope and it shouldn't be
        Game.shared.display("What \(item.name)?")
        Logger.error("WOAAAH BUDDY WHAT HAPPENED?")

        return false
    }
}
