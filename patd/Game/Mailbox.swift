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

    // This is poorly implemented, just testing, delete me FIXME: DELETE
    var containsLeaflet: Bool {
        for item in self.items {
            if item.name == "leaflet" {
                return true
            }
        }

        return false
    }

    var leafIntent: GetItemIntent?

    override var intents: [Intent] {
        if containsLeaflet {
            if let intent = leafIntent {
                return _intents + [intent]
            }
        }

        return _intents
    }

    init() {
        super.init(name: "mailbox")

        self.properties = [.Openable, .Renderable, .Container]
        self.description = "a small, red, wooden mailbox"
        self.renderText = "There is a small mailbox here."

        let leaflet = Item(name: "leaflet", properties: [.Gettable])

        self.add(item: leaflet)

        // FIXME: Use property observer on properties to auto register and unregister these
        self._intents = [LookInsideItemIntent(item: self), OpenItemIntent(item: self), CloseItemIntent(item: self)]

        self.leafIntent = GetItemIntent(item: leaflet)
        self.leafIntent?.hooble = {
            () -> Bool in
                self.remove(item: leaflet)
                Game.shared.player.add(toInventory: leaflet)

                return true
        }
    }

    override func item(didOpen item: Item) {
        Game.shared.display("You open the mailbox", noReturn: true)

        if containsLeaflet {
            Game.shared.display(" revealing a small leaflet.")
        }
    }

    override func item(didClose item: Item) {
        super.item(didClose: item)
    }
}
