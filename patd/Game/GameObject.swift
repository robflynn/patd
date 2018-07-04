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
    var _buffer: String = ""

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

    internal func buffer(_ message: String, noReturn: Bool = false) {
        if noReturn {
            self._buffer += message
        } else {
            self._buffer += message + "\n"
        }
    }

    internal func flushBuffer() -> String {
        defer {
            self._buffer = ""
        }

        return self._buffer
    }

}
