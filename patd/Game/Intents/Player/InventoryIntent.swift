//
//  InventoryIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class InventoryIntent: Intent {
    override func triggers() -> [String] {
        return ["inventory", "inv", "i"]
    }

    override func execute() -> Bool {
        if Game.shared.player.inventory.isEmpty {
            Game.shared.display("You are not carrying any items.")
        } else {
            Game.shared.display(Game.shared.player.inventory.map { $0.name }.joined(separator: ", "))
        }

        return true
    }
}
