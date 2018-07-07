//
//  MapParser.swift
//  patd
//
//  Created by Rob Flynn on 7/3/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

enum GameLoaderError: Error {
    case unknownError
}

final class GameLoader {
    struct MonsterData: Decodable {
        var id: GameObjectID?
        var name: String
        var description: String?
    }

    struct EscapeData: Decodable {
        var commands: [String]
        var target: String
    }

    struct ExitData: Decodable {
        var id: GameObjectID?
        var direction: String
        var target: GameObjectID
    }
    
    struct ItemData: Decodable {
        var id: GameObjectID?
        var name: String
        var object: String?
        var description: String?
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
        var escapes: [EscapeData]?
        var monsters: [MonsterData]?
    }
    
    struct Map: Decodable {
        let rooms: [RoomData]
    }
    
    public func parse(jsonString: String) throws {
        
        guard let data = jsonString.data(using: .utf8, allowLossyConversion: false) else { print("There wasn't anything to parse?"); throw GameLoaderError.unknownError }
        
        guard let map = try? JSONDecoder().decode(Map.self, from: data) else {
            print("There was some kind of error parsing the map.")

            throw GameLoaderError.unknownError
        }

        for roomData in map.rooms {
            let room = self.createRoom(fromData: roomData)
            Game.shared.add(room: room)
        }
    }

    func stringClassFromString(_ className: String) -> AnyClass! {

        /// get namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;

        /// get 'anyClass' with classname and namespace
        let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!;

        // return AnyClass!
        return cls;
    }

    func createMonster(fromData monsterData: GameLoader.MonsterData) -> Monster {
        let monster = Monster(name: monsterData.name)

        if let id = monsterData.id { monster.Id = id }

        if let description = monsterData.description {
            monster.description = description
        }

        return monster
    }

    func createItem(fromData itemData: GameLoader.ItemData) -> Item {
        var item: Item

        // FIXME: Do some proper reflection here or decide how you want to handle custom objects.
        switch(itemData.object) {
        case "Mailbox":
            item = Mailbox()
        case "SlipperyFish":
            item = SlipperyFish()
        default:
            // FIXME: We don't know how to return this object type
            item = Item(name: itemData.name)
        }

        if let id = itemData.id { item.Id = id }

        if let description = itemData.description { item.description = description }
        if let envText = itemData.environmentalText { item.environmentalText = envText }

        if let traits = itemData.traits {
            for traitData in traits {
                // FIXME: Don't allow bad traits, throw probably
                guard let trait = Item.Trait(rawValue: traitData) else { continue }

                item.add(trait: trait)
            }
        }

        if let childItems = itemData.items {
            for childItemData in childItems {
                let childItem = self.createItem(fromData: childItemData)

                item.add(item: childItem)
            }
        }

        return item
    }

    func createRoom(fromData roomData: GameLoader.RoomData) -> Room {
        let room = Room()
        room.name = roomData.name
        room.description = roomData.description

        if let id = roomData.id { room.Id = id }

        if let exits = roomData.exits {
            for exitData in exits {
                // FIXME: Don't allow invalid directions, we'll want to throw some kind of error here
                guard let direction = Direction(rawValue: exitData.direction) else { continue }

                let exit = Exit(direction: direction, target: exitData.target)

                room.add(exit: exit)
            }
        }

        if let items = roomData.items {
            for itemData in items {

                let item = self.createItem(fromData: itemData)

                room.add(item: item)
            }
        }

        if let monsters = roomData.monsters {
            for monsterData in monsters {
                let monster = self.createMonster(fromData: monsterData)

                room.add(character: monster)
            }
        }


        // FIXME: POC
        if let escapes = roomData.escapes {
            for escape in escapes {
                room.addEscape(escape)
            }
        }


        return room
    }

}
