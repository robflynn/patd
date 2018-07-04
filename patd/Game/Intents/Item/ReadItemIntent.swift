//
//  ReadItemIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/3/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class ReadItemIntent: Intent {
    var item: Item

    init(item: Item) {
        self.item = item
    }

    override func triggers() -> [String] {
        var commands: [String] = []
        let actions = ["read"]

        for action in actions {
            commands.append("\(action) \(item.name.lowercased())")
            commands.append("\(action) \(item.nameWithArticle().lowercased())")
        }

        return commands
    }

    override func execute() -> Bool {
        return self.item.read()
    }
}
