//
//  UnlockItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class UnlockItemIntent: Intent {
    var intentType: IntentType {
        return .UnlockItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["unlock"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) the \(item.name.lowercased())")
        }

        self.item = item
    }

    func execute() -> Bool {
        if !item.isUnlockable {
            Game.shared.display("You can't unlock that.")

            return false
        }

        return item.unlock()
    }
}
