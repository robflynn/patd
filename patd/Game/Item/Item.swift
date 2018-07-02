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
        case Lockable
        case Renderable
    }

    var name: String
    var description: String {
        var blurbs = [self._description]

        if self.isOpenable {
            blurbs.append("The \(self.name) is \(self.isOpen ? "open" : "closed").")
        }

        return blurbs.joined(separator: " ")
    }
    var renderText: String?

    private var _description: String

    var intents: [Intent] = []
    private(set) var properties: [Item.Property] = []

    var isGettable: Bool {
        return self.properties.contains(.Gettable)
    }

    var isOpenable: Bool {
        return self.properties.contains(.Openable)
    }

    var isLockable: Bool {
        return self.properties.contains(.Lockable)
    }

    var isRenderable: Bool {
        return self.properties.contains(.Renderable)
    }

    var isOpen: Bool {
        didSet {
            if !self.isOpenable {
                self.isOpen = false
            }
        }
    }

    var isLocked: Bool {
        didSet {
            if !self.isLockable {
                self.isLocked = false
            }
        }
    }

    init(name: String, description: String, properties: [Item.Property]) {
        self.name = name
        self._description = description
        self.properties = properties
        self.isOpen = false
        self.isLocked = false

        super.init()

        self.intents.append(ExamineItemIntent(item: self))

        self.intents.append(GetItemIntent(item: self))
        self.intents.append(DropItemIntent(item: self))
        
        self.intents.append(OpenItemIntent(item: self))
        self.intents.append(CloseItemIntent(item: self))

        self.intents.append(UnlockItemIntent(item: self))
    }

    func render() {
        if let text = self.renderText {
            display(text)
        }
    }
}
