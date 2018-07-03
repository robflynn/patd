//
//  TakeExitIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class TakeExitIntent: Intent {
    var triggers: [String] = []
    private(set) var exit: Exit

    init(with exit: Exit) {
        // Add the direction as a trigger
        triggers.append(exit.direction.Name)

        // And all of the aliases
        for alias in exit.direction.Aliases {
            triggers.append(alias)
        }

        triggers.append("take \(exit.direction.Name.lowercased())")
        triggers.append("go \(exit.direction.Name.lowercased())")
        triggers.append("take \(exit.direction.Name.lowercased()) exit")
        triggers.append("take the \(exit.direction.Name.lowercased()) exit")

        self.exit = exit
    }

    func execute() -> Bool {
        Game.shared.player.room = self.exit.target
        Game.shared.currentRoom.render()

        return true
    }
}
