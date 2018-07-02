//
//  Object.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

typealias ObjectID = UUID

class GameObject: Equatable {
    var Id: ObjectID = ObjectID()

    let instantiatedAt: Date = Date()
    var instanceAge: TimeInterval {
        return instantiatedAt.timeIntervalSinceNow
    }

    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.Id.uuidString == rhs.Id.uuidString
    }
}
