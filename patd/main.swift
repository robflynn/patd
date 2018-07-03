//
//  main.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Patd: GameProtocol {
    let game = Game.shared
 
    var gameState: GameState {
        return self.game.State
    }

    init() {
        self.game.delegate = self
        
        if !loadGameData() {
            // FIXME: Handle this
            print("There was an error reading the map data. Thing's are not going to work correctly.")
        }
    }
    
    func loadGameData() -> Bool {
        do {
            guard let  map = try? MapParser.parse() else { return false }
            
            for roomData in map.rooms {
                let room = Room()
                room.name = roomData.name
                room.description = roomData.description
                
                if let id = roomData.id { room.Id = id }
                
                if let exits = roomData.exits {
                    for exitData in exits {
                        
                        // Let's just ignore bad exits for now, later we'll probably want to throw an error
                        // We'll want to be able to reference exits to rooms that may not yet be loaded
                        // so ....
                        guard let targetRoom = Game.shared.room(withID: exitData.target) else { continue }
                        
                        // Don't allow invalid directions
                        guard let direction = Direction(rawValue: exitData.direction) else { continue }
                        
                        let exit = Exit(direction: direction, target: targetRoom)
                        
                        room.add(exit: exit, mutual: exitData.mutual)
                    }
                }
                
                Game.shared.add(room: room)
            }
            
            // Let's just drop the player in the first room if one exists
            if let firstRoom = Game.shared.rooms.first {
                Game.shared.player.room = firstRoom
            }
            
            return true
        } catch {
            return false
        }
    }

    func getUserInput() -> String? {
        print("> ", terminator: "")

        let input = readLine()

        return input
    }

    func run() {
        game.run()

        game.render()
        while gameState == .Running {
            // Exit if we can't get input from the user, handle with proper exceptions later
            guard let input = self.getUserInput() else { return }

            game.handlePlayerInput(input)
        }
    }


    // MARK: GameProtocol
    func game(exitedState state: GameState) {
    }

    func game(enteredState state: GameState) {
    }

    func game(playerDidEnterRoom room: Room) {
        game.render()
    }

    func game(playerDidExitRoom room: Room) {
    }

}

Patd().run()
