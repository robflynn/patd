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
        buffer.clear()
        
        if Game.shared.player.inventory.isEmpty {
            buffer.send("You are not carrying any items.")
        } else {
            buffer.send("You are carrying ", noReturn: true)
            buffer.send(Game.shared.player.inventory.items.listified())
        }

        Game.shared.display(buffer.flush())

        return true
    }
}
