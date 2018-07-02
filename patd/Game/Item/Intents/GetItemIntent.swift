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
}