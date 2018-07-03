//
//  QuitGameIntent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class QuitGameIntent: Intent {
    var triggers: [String] = ["quit"]

    func execute() -> Bool {
        Game.shared.State = .Exiting

        return true
    }
}
