//
//  CloseItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class CloseItemIntent: Intent {
    var intentType: IntentType {
        return .CloseItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["close", "shut"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) the \(item.name.lowercased())")
        }

        self.item = item
    }
}
