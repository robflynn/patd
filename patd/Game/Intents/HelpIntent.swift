//
//  HelpIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class HelpIntent: Intent {
    var triggers: [String] = ["help"]

    func execute() -> Bool {
        Game.shared.display("We will eventually have a help screen that displays here.")

        return true
    }
}
