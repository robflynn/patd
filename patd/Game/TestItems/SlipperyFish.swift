//
//  SlipperyFish.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class PushFishIntent: Intent {
    override func triggers() -> [String] {
        return ["use fish as door", "push fish", "push slippery fish"]
    }

    override func execute() -> Bool {
        Game.shared.display("you push the fish. it is hard to push because it bends and makes your hands slide. you failed at using the slippery fish as a door.")

        return false
    }
}

class SlipperyFish: Item {
    init() {
        super.init(name: "slippery fish")
        
        self.description = "it is slippery and fishy because it is a slippery fish."
        self.traits = [.Gettable, .Renderable]
        self.environmentalText = "There is a slippery fish on the ground."

        self.add(intent: PushFishIntent())
    }
}
