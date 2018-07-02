//
//  Mailbox.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Mailbox: Item {
    var items: [Item] = []
    var leaflet: Item?
    
    // FIXME: This needs to be cleaned up
    var internalDescription: String {
        if let leaflet = self.leaflet {
            if self.items.contains(leaflet) {
                return "In the \(self.name) is a small leaflet"
            } else {
               return "The mailbox is empty."
            }
        }
        
      return "The mailbox is empty."
    }

    init() {
        super.init(name: "mailbox", properties: [.Openable, .Renderable, .Lockable])

        self.lockState = .Locked

        self.description = "You see a small wooden mailbox."
        self.renderText = "There is a small mailbox here."
        
        self.openableDelegate = self
        self.lockableDelegate = self
        
        self.leaflet = Item(name: "leaflet", properties: [.Gettable])
                
        if let leaflet = self.leaflet {
            leaflet.description = """
            WELCOME TO ZORK
            
            ZORK is a game of adventure, danger, and low cunning.  In it you will explore some of the most amazing territory ever seen by mortal man.  Hardened adventurers have run screaming from the terrors contained within!
            
            In ZORK the intrepid explorer delves into the forgotten secrets of a lost labyrinth deep in the bowels of the earth, searching for vast treasures long hidden from prying eyes, treasures guarded by fearsome monsters and diabolical traps!
            
            No PDP-10 should be without one!
            
            ZORK was created at the MIT Laboratory for Computer Science, by Tim Anderson, Marc Blank, Bruce Daniels, and Dave Lebling.  It was inspired by the ADVENTURE game of Crowther and Woods, and the long tradition of fantasy and science fiction adventure.  ZORK was originally written in MDL (alias MUDDLE).  The current version was translated from MDL into Inform by Ethan Dicks <erd@infinet.com>.
            
            On-line information may be available using the HELP and INFO commands (most systems).
            
            Direct inquiries, comments, etc. by Net mail to erd@infinet.com.
            
            (c) Copyright 1978,1979 Massachusetts Institute of Technology.
            All rights reserved.
            """
            self.items.append(leaflet)
            
            self.intents.append(LookInsideItemIntent(item: self))
        }
    }
    
    override func item(didOpen item: Item) {
        var text = ["You open the \(self.name)"]
        
        if let leaflet = self.leaflet {
            if self.items.contains(leaflet) {
                text.append("revealing a small leaflet")
            }
        }
        
        display(text.joined(separator: " ") + ".")
    }
}
