//
//  CloseItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class CloseItemIntent: Intent {
    var item: Item

    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        var triggers: [String] = []
        let actions = ["close", "shut"]

        for action in actions {
            triggers.append("\(action) \(item.name.lowercased())")
            triggers.append("\(action) \(item.nameWithArticle().lowercased())")
        }

        return triggers
    }

    override func execute() -> Bool {
        if !item.isClosable {
            Game.shared.display("You can't close that.")

            return false
        }

        return item.close()
    }
}
