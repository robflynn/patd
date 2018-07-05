//
//  Object.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

typealias GameObjectID = String

class GameObject: Equatable {
    var Id: GameObjectID
    internal let buffer = MessageBuffer()

    let instantiatedAt: Date = Date()
    var instanceAge: TimeInterval {
        return instantiatedAt.timeIntervalSinceNow
    }

    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.Id == rhs.Id
    }
    
    init() {
        self.Id = UUID().uuidString
    }
}
