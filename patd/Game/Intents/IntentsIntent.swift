//
//  IntentsIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class IntentsIntent: Intent {
    override func triggers() -> [String] {
        return ["intents", "ints"]
    }

    override func execute() -> Bool {
        for intent in Game.shared.registeredIntents() {
            for trigger in intent.triggers() {
                print(trigger)
            }
        }

        return true
    }
}
