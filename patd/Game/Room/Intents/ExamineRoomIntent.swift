//
//  ExamineRoomIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class ExamineRoomIntent: Intent {
    var triggers: [String] = ["examine room", "look around", "look at surroundings", "look at my surroundings", "look around the room", "look at room"]

    func execute() -> Bool {
        Game.shared.currentRoom.render()

        return true
    }
}
