//
//  Room.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Room {
    var name: String = "A Room"
    var description: String = "A nondescript room."

    init() {        
    }

    func render() {
        display(name)
        display(description)
    }
}
