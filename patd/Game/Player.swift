//
//  Player.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Player: GameObject {
    var room: Room? {
        didSet {
            if let oldRoom = oldValue {
                oldRoom.remove(player: self)
            }

            if let newRoom = self.room {
                newRoom.add(player: self)
            }
        }
    }

    override init() {
        super.init()
    }
}
