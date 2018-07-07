//
//  Player.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Player: Character {
    init() {
        super.init(name: "Player")

        self.add(intent: InventoryIntent())
    }
}
