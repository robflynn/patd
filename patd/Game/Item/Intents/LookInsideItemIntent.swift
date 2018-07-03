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
        let actions = ["look", "peer", "gaze"]
        let prepositions = ["at", "into", "inside", "in to"]
        
        for action in actions {
            for preposition in prepositions {
                triggers.append("\(action) \(preposition) \(item.name)")
                triggers.append("\(action) \(preposition) the \(item.name)")
            }
        }
        
        self.item = item
    }

    func execute() -> Bool {
        // FIXME: For now we're just going to assume it's always a mailbox as I'm not sure how I want to structure this yet
        guard let mailbox = item as? Mailbox else { return false }

        if mailbox.isOpen == false {
            Game.shared.display("The \(item.name) is not open.")

            return false
        }

        Game.shared.display(mailbox.internalDescription)

        return true
    }
}
