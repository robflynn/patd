//
//  Leaflet.swift
//  patd
//
//  Created by Rob Flynn on 7/3/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class Leaflet: Item {
    init() {
        super.init(name: "leaflet")
        
        self.description = """
"WELCOME TO ZORK!

ZORK is a game of adventure, danger, and low cunning. In it you will explore some of the most amazing territory ever seen by mortals. No computer should be without one!"
"""
        self.traits = [.Gettable, .Readable]

        self.add(intent: ReadItemIntent(item: self))
    }

    override func read() -> Bool {
        if let text = description {
            Game.shared.display(text)

            return true
        }

        return false
    }
}
