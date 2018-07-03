//
//  ExamineItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class ExamineItemIntent: Intent {
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

    func execute() -> Bool {
        Game.shared.display(self.item.description)

        return true
    }
}
