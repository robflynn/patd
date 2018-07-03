//
//  OpenItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class OpenItemIntent: Intent {
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

    func execute() -> Bool {
        if !self.item.isOpenable {
            Game.shared.display("You cannot open that.")

            return false
        }

        return self.item.open()
    }
}
