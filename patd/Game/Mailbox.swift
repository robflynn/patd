//
//  Mailbox.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Mailbox: Item {
    // FIXME: This needs to be cleaned up
    var internalDescription: String {
        return "The mailbox is empty."
    }

    init() {
        super.init(name: "mailbox")

        self.properties = [.Openable, .Renderable, .Container]
        self.description = "a small, red, wooden mailbox"
        self.renderText = "There is a small mailbox here."

        let leaflet = Item(name: "leaflet", properties: [.Gettable])

        self.add(item: leaflet)

        self.intents = [LookInsideItemIntent(item: self), OpenItemIntent(item: self)]
    }
}
