//
//  Mailbox.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

// FIXME: I think we need to allow for passthrough intents
class LeafletIntent: GetItemIntent {
    var mailbox: Mailbox

    init(mailbox: Mailbox, leaflet: Item) {
        self.mailbox = mailbox

        super.init(item: leaflet)
    }

    override func execute() -> Bool {
        mailbox.remove(item: item)
        Game.shared.player.add(toInventory: item)

        Game.shared.display("You get the leaflet.")

        return true
    }
}


// This is a proof of concept for an item contain that pushes it's
// content's intents up to the room scope when the container is open.
//
// I may extract this out as a generic item property, or perhaps it will
// be a property of a container. it probably makes more sense to
// exist in the container
class Mailbox: Item {
    // This is poorly implemented, just testing, delete me FIXME: DELETE
    var containsLeaflet: Bool {
        for item in self.items {
            if item.name == "leaflet" {
                return true
            }
        }

        return false
    }

    var leafIntent: LeafletIntent?

    init() {
        super.init(name: "mailbox")
        
        self.description = "a small, red, wooden mailbox"
        self.environmentalText = "There is a small mailbox here."
        
        self.traits = [.Openable, .Renderable, .Container]

        let leaflet = Leaflet()
        self.add(item: leaflet)

        self.add(intent: LookInsideItemIntent(item: self))
        self.add(intent: OpenItemIntent(item: self))
        self.add(intent: CloseItemIntent(item: self))

        self.leafIntent = LeafletIntent(mailbox: self, leaflet: leaflet)
    }

    override func registeredIntents() -> [Intent] {
        if containsLeaflet && isOpen {
            if let intent = leafIntent {
                return intents + [intent]
            }
        }

        return intents
    }

    override func item(didOpen item: Item) {
        if containsLeaflet {
            Game.shared.display("Opening the small mailbox reveals a leaflet.")
        } else {
            super.item(didOpen: item)
        }
    }

    override func item(didClose item: Item) {
        super.item(didClose: item)
    }
}
