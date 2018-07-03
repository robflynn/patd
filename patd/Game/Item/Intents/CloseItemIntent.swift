//
//  CloseItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class CloseItemIntent: Intent {
    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["close", "shut"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) \(item.named().lowercased())")
        }

        self.item = item
    }

    func execute() -> Bool {
        if !item.isClosable {
            Game.shared.display("You can't close that.")

            return false
        }

        return item.close()
    }
}
