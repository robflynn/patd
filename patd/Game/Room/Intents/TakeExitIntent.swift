//
//  TakeExitIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class TakeExitIntent: Intent {
    var intentType: IntentType {
        return .TakeExit
    }

    var triggers: [String] = []
    private(set) var exit: Exit

    init(with exit: Exit) {
        // Add the direction as a trigger
        triggers.append(exit.direction.Name)

        // And all of the aliases
        for alias in exit.direction.Aliases {
            triggers.append(alias)
        }

        self.exit = exit
    }
}
