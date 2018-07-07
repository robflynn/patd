//
//  EscapeRoomIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/4/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

typealias Escape = GameLoader.EscapeData

class EscapeRoomIntent: Intent {
    private var escape: Escape

    init(escape: Escape) {
        self.escape = escape
    }

    override func triggers() -> [String] {
        return escape.commands
    }

    override func execute() -> Bool {
        if let targetRoom = Game.shared.room(withID: escape.target) {
            Game.shared.player.room = targetRoom

            // FIXME: We shouldn't be doing this, instead we should be firing off an event that the user changed rooms
            return Game.shared.currentRoom.examine()

            return true
        }

        return false
    }
}
