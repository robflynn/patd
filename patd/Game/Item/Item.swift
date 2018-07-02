//
//  Item.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Item: GameObject {

    enum Property {
        case Openable
        case Gettable
    }

    var name: String
    var description: String

    var intents: [Intent] = []
    private(set) var properties: [Item.Property] = []

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

    init(name: String, description: String, properties: [Item.Property]) {
        self.name = name
        self.description = description
        self.properties = properties
        self.isOpen = false

        super.init()

        self.intents.append(ExamineItemIntent(item: self))
        self.intents.append(DropItemIntent(item: self))

        self.intents.append(GetItemIntent(item: self))
        self.intents.append(OpenItemIntent(item: self))
    }
}
