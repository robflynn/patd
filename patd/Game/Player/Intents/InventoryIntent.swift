//
//  InventoryIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class InventoryIntent: Intent {
    var intentType: IntentType  {
        return .Inventory
    }

    var triggers: [String] = []

    init() {
        triggers.append("inventory")
        triggers.append("inv")
        triggers.append("i")
    }
}
