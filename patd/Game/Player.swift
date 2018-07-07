//
//  Player.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Player: Character {
    private var intents: [Intent] = []

    init() {
        super.init(name: "Player")

        self.intents.append(InventoryIntent())
    }

    func registeredIntents() -> [Intent] {
        var tmp: [[Intent]] = []

        tmp.append(self.intents)

        for item in self._inventory {
            Logger.debug(" -> \(item.name)")

            tmp.append(item.intents)
        }

        return tmp.flatMap{ $0 }
    }
}
