//
//  Monster.swift
//  patd
//
//  Created by Rob Flynn on 7/6/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class Monster: Character {
    var description: String?

    override init(name: String) {
        super.init(name: name)

        self.add(intent: ExamineMonsterIntent(monster: self))
    }
}
