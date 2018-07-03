//
//  Direction.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

enum Direction: String {
    case North = "north"
    case NorthEast = "northeast"
    case East = "east"
    case SouthEast = "southeast"
    case South = "south"
    case SouthWest = "southwest"
    case West = "west"
    case NorthWest = "northwest"

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

    var Opposite: Direction {
        switch(self) {
        case .North:
            return .South
        case .NorthEast:
            return .SouthWest
        case .East:
            return .West
        case .SouthEast:
            return .NorthWest
        case .South:
            return .North
        case .SouthWest:
            return .NorthEast
        case .West:
            return .East
        case .NorthWest:
            return .SouthEast
        }
    }
}
