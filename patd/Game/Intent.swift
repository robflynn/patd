//
//  Intent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

// This intent system is going to be very basic for now
enum IntentType {
    case TakeExit
    case QuitGame
    case GetItem
    case LookAtItem
    case DropItem
    case Inventory
    case ExamineRoom
    case OpenItem
    case CloseItem
}

protocol Intent {
    var intentType: IntentType { get }
    var triggers: [String] { get }
}
