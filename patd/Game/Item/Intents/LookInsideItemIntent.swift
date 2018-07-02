//
//  LookInsideItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class LookInsideItemIntent: Intent {
    var intentType: IntentType {
        return .LookInsideItem
    }
    
    var triggers: [String] = []
    
    var item: Item
    
    init(item: Item) {
        let actions = ["look inside", "peer into", "look into", "look in to", "peer in to"]
        
        for action in actions {
            triggers.append("\(action) \(item.name)")
            triggers.append("\(action) the \(item.name)")
        }
        
        self.item = item
    }
}
