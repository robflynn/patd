//
//  Lockable.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

enum LockState {
    case unlocked
    case locked
}

protocol Lockable {
    // Required properties
    var lockState: LockState { get set }

    func unlock() -> Bool
    func lock() -> Bool
}

extension Lockable  {
    var isUnlockable: Bool { return true }
    var isLockable: Bool { return true }

    var isLocked: Bool { return self.lockState == .locked }
    var isUnlocked: Bool { return self.lockState == .unlocked }

    mutating func unlock() -> Bool {
        if isUnlockable {
            self.lockState = .unlocked

            return true
        }

        return false
    }

    mutating func lock() -> Bool {
        if isLockable {
            self.lockState = .locked

            return true
        }

        return false
    }
}
