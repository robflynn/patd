//
//  Lockable.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

enum LockState {
    case Unlocked
    case Locked
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

    var isLocked: Bool { return self.lockState == .Locked }
    var isUnlocked: Bool { return self.lockState == .Unlocked }

    mutating func unlock() -> Bool {
        if isUnlockable {
            self.lockState = .Unlocked

            return true
        }

        return false
    }

    mutating func lock() -> Bool {
        if isLockable {
            self.lockState = .Locked

            return true
        }

        return false
    }
}
