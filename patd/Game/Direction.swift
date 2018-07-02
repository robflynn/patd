//
//  Direction.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

enum Direction: String {
    case North
    case NorthEast
    case East
    case SouthEast
    case South
    case SouthWest
    case West
    case NorthWest

    var Name: String {
        return self.rawValue.lowercased()
    }

    var Aliases: [String] {
        switch(self) {
        case .North:
            return ["n"]
        case .NorthEast:
            return ["ne", "north east"]
        case .East:
            return ["e"]
        case .SouthEast:
            return ["se", "south east"]
        case .South:
            return ["s"]
        case .SouthWest:
            return ["sw", "south west"]
        case .West:
            return ["w"]
        case .NorthWest:
            return ["nw", "north west"]
        }
    }
}
