//
//  Exit.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

struct Exit {
    var direction: Direction
    var target: GameObjectID
    
    var targetRoom: Room? {
        return Game.shared.room(withID: target)
    }
}
