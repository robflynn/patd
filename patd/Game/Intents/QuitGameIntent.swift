//
//  QuitGameIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class QuitGameIntent: Intent {
    override func triggers() -> [String] {
        return ["quit"]
    }

    override func execute() -> Bool {
        Game.shared.State = .Exiting

        return true
    }
}
