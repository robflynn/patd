//
//  TraitsIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/4/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class TraitsIntent: Intent {
    private var item: Item

    override func triggers() -> [String] {
        return ["traits \(item.name)"]
    }

    override func execute() -> Bool {
        buffer.clear()
        buffer.send("Traits are:")
        buffer.send(self.item.traits.map { $0.rawValue }.joined(separator: ", "))

        Game.shared.display(buffer.flush())

        return true
    }

    init(item: Item) {
        self.item = item
    }
}
