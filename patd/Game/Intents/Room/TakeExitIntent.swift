//
//  TakeExitIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class TakeExitIntent: Intent {
    private(set) var exit: Exit

    init(with exit: Exit) {
        self.exit = exit
    }

    override func triggers() -> [String] {
        var triggers: [String] = []

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

        return triggers
    }

    override func execute() -> Bool {
        guard let targetRoom = Game.shared.room(withID: exit.target) else {
            // FIXME: The room doesn't exist, we need to know about. Do we want to store exits separately or just do a validation pass at the end of parsing?
            
            Logger.error("Could not find room: \(exit.target)")
            
            return false
        }
        
        Game.shared.player.room = targetRoom
        Game.shared.currentRoom.examine()

        return true
    }
}
