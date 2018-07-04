//
//  OpenItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class OpenItemIntent: Intent {
    var item: Item

    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        var triggers: [String] = []
        let actions = ["open"]

        for action in actions {
            triggers.append("\(action) \(item.name.lowercased())")
            triggers.append("\(action) \(item.nameWithArticle())")
        }

        return triggers
    }

    override func execute() -> Bool {
        if !self.item.isOpenable {
            Game.shared.display("You cannot open that.")

            return false
        }

        return self.item.open()
    }
}
