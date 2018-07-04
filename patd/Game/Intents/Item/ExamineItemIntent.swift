//
//  ExamineItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class ExamineItemIntent: Intent {
    var item: Item

    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        let actions = ["look", "look at", "observe", "examine", "inspect"]

        var triggers: [String] = []

        for action in actions {
            triggers.append("\(action) \(item.name.lowercased())")
            triggers.append("\(action) the \(item.name.lowercased())")
        }

        return triggers
    }

    override func execute() -> Bool {
        return self.item.examine()
    }
}
