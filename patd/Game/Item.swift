//
//  Item.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class GetItemIntent: Intent {
    var intentType: IntentType {
        return .getItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["get", "pick up", "loot", "grab", "fetch"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
        }

        self.item = item
    }
}

class LookAtItemIntent: Intent {
    var intentType: IntentType {
        return .lookAtItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["look", "look at", "observe", "examine", "inspect"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
        }

        self.item = item
    }
}

class DropItemIntent: Intent {
    var intentType: IntentType {
        return .dropItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["drop"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
        }

        self.item = item
    }
}

class Item: GameObject {
    var name: String
    var description: String
    var intents: [Intent] = []

    init(name: String, description: String) {
        self.name = name
        self.description = description

        super.init()

        self.intents.append(GetItemIntent(item: self))
        self.intents.append(LookAtItemIntent(item: self))
        self.intents.append(DropItemIntent(item: self))
    }
}
