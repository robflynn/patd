//
//  ExamineMonsterIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/6/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class ExamineMonsterIntent: Intent {
    var monster: Monster

    init(monster: Monster) {
        self.monster = monster
    }

    override func triggers() -> [String] {
        let actions = ["look", "look at", "observe", "examine", "inspect"]

        var triggers: [String] = []

        for action in actions {
            triggers.append("\(action) \(monster.name.lowercased())")
            triggers.append("\(action) the \(monster.name.lowercased())")
        }

        return triggers
    }

    override func execute() -> Bool {
        self.buffer.clear()

        if let description = monster.description {
            self.buffer.send(description)
        } else {
            // FIXME: Hmmm....
            self.buffer.send("You see nothing special.")
        }

        Game.shared.display(self.buffer.flush())

        return true
    }
}
