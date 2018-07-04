//
//  LookInsideItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class LookInsideItemIntent: Intent {
    var item: Item
    
    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        let actions = ["look", "peer", "gaze"]
        let prepositions = ["at", "into", "inside", "in to", "in"]

        var commands: [String] = []

        for action in actions {
            for preposition in prepositions {
                commands.append("\(action) \(preposition) \(item.name)")
                commands.append("\(action) \(preposition) the \(item.name)")
            }
        }

        return commands
    }

    override func execute() -> Bool {
        if !item.isContainer {
            Game.shared.display("You can't look look in that.")

            return false
        }

        // Is this container openable? If so, it has to be open to look inside it
        if item.isOpenable && item.isClosed {
            Game.shared.display("You can't see inside it.")

            return false
        }

        Game.shared.display(item.interiorDescription)

        return true
    }
}
