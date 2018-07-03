//
//  ReadItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/3/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class ReadItemIntent: Intent {
    var triggers: [String] = []

    var item: Item

    init(item: Item) {
        let actions = ["read"]

        for action in actions {
            self.triggers.append("\(action) \(item.name.lowercased())")
            self.triggers.append("\(action) \(item.named()) \(item.name.lowercased())")
        }

        self.item = item
    }

    func execute() -> Bool {
        Game.shared.display(self.item.description)

        return true
    }
}
