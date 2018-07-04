//
//  UnlockItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class UnlockItemIntent: Intent {
    var item: Item

    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        var triggers: [String] = []

        let actions = ["unlock"]

        for action in actions {
            triggers.append("\(action) \(item.name.lowercased())")
            triggers.append("\(action) \(item.nameWithArticle())")
        }

        return triggers
    }

    override func execute() -> Bool {
        if !item.isUnlockable {
            Game.shared.display("You can't unlock that.")

            return false
        }

        return item.unlock()
    }
}
