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
    struct ExitData: Decodable {
        var id: GameObjectID?
        var direction: String
        var target: GameObjectID
    }
    
    struct ItemData: Decodable {
        var name: String
        var description: String
        var traits: [String]?
        var environmentalText: String?
        var items: [ItemData]?
    }
    
    struct RoomData: Decodable {
        var id: GameObjectID?
        var name: String
        var description: String
        var exits: [ExitData]?
        var items: [ItemData]?
    }
    
    struct Map: Decodable {
        let rooms: [RoomData]
    }
    
    public static func parse(jsonString: String) throws -> Map {
        
        guard let data = jsonString.data(using: .utf8, allowLossyConversion: false) else { print("There wasn't anything to parse?"); throw MapParsingError.unknownError }
        
        guard let map = try? JSONDecoder().decode(Map.self, from: data) else {
            print("There was some kind of error parsing the map.")

            throw MapParsingError.unknownError
        }

        return map
    }
}
