//
//  Openable.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

enum OpenState {
    case open, closed
}

protocol Openable {
    // Required properties
    var openState: OpenState { get set }
    
    func open() -> Bool
    func close() -> Bool
}

extension Openable  {
    var isOpenable: Bool { return true }
    var isClosable: Bool { return true }

    var isOpen: Bool { return self.openState == .open }
    var isClosed: Bool { return self.openState == .closed }
    
    mutating func open() -> Bool {
        if isOpenable {
            self.openState = .open

            return true
        }

        return false
    }
    
    mutating func close() -> Bool {
        if isClosable {
            self.openState = .closed

            return true
        }

        return false
    }
}
