//
//  Openable.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

enum OpenState {
    case Open
    case Closed
}

protocol Openable {
    // Required properties
    var openState: OpenState { get set }
    
    func open() -> Bool
    func close() -> Bool
}

extension Openable  {
    var isOpenable: Bool { return true }
    var isOpen: Bool { return self.openState == .Open }
    var isClosed: Bool { return self.openState == .Closed }
    
    mutating func open() -> Bool {
        self.openState = .Open
        
        return true
    }
    
    mutating func close() -> Bool {
        self.openState = .Closed
        
        return true
    }
}
