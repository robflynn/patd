//
//  Item.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class OpenItemIntent: Intent {
    var intentType: IntentType {
        return .OpenItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["open"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) the \(item.name.lowercased())")
        }

        self.item = item
    }
}

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

class LookAtItemIntent: Intent {
    var intentType: IntentType {
        return .LookAtItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["look", "look at", "observe", "examine", "inspect"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) the \(item.name.lowercased())")
        }

        self.item = item
    }
}

class DropItemIntent: Intent {
    var intentType: IntentType {
        return .DropItem
    }

    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["drop"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) the \(item.name.lowercased())")
        }

        self.item = item
    }
}

enum ItemProperty {
    case Openable
    case Gettable
}

class Item: GameObject {
    var name: String
    var description: String

    var intents: [Intent] = []
    private(set) var properties: [ItemProperty] = []

    var isGettable: Bool {
        return self.properties.contains(.Gettable)
    }

    var isOpenable: Bool {
        return self.properties.contains(.Openable)
    }

    var isOpen: Bool {
        didSet {
            if !self.isOpenable {
                self.isOpen = false
            }
        }
    }

    init(name: String, description: String, properties: [ItemProperty]) {
        self.name = name
        self.description = description
        self.properties = properties
        self.isOpen = false

        super.init()

        self.intents.append(LookAtItemIntent(item: self))
        self.intents.append(DropItemIntent(item: self))

        self.intents.append(GetItemIntent(item: self))
        self.intents.append(OpenItemIntent(item: self))
    }
}
