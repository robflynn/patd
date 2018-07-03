//
//  MapParser.swift
//  patd
//
//  Created by Rob Flynn on 7/3/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

enum MapParsingError: Error {
    case unknownError
}

final class MapParser {
    static var jsonString: String = """
{
    "rooms": [
        {
            "id": "wohouse",
            "name": "West of House",
            "description": "This is an open field west of a white house, with a boarded front door.",
            "exits": [
                {
                    "direction": "west",
                    "target": "forest1"
                }
            ]
        },
        {
            "id": "forest1",
            "name": "Forest",
            "description": "This is a forest, with trees in all directions around you. You can see sunlight to the east.",
            "exits": [
                {
                    "direction": "east",
                    "target": "wohouse",
                }
            ]
        }
    ]
}
"""

    struct ExitData: Decodable {
        var id: GameObjectID?
        var direction: String
        var target: GameObjectID
    }
    
    struct RoomData: Decodable {
        var id: GameObjectID?
        var name: String
        var description: String
        var exits: [ExitData]?
    }
    
    struct Map: Decodable {
        let rooms: [RoomData]
    }
    
    public static func parse() throws -> Map {
        
        guard let data = MapParser.jsonString.data(using: .utf8, allowLossyConversion: false) else { print("There wasn't anything to parse?"); throw MapParsingError.unknownError }
        
        guard let map = try? JSONDecoder().decode(Map.self, from: data) else {
            print("There was some kind of error parsing the map.")

            throw MapParsingError.unknownError
        }

        return map
    }
}
