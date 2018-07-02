//
//  Logger.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

class Logger {
    // FIXME: DRY this up
    static func debug(_ items: Any...) {
        print("[DEBUG] ", terminator: "")

        for item in items {
            print(item, terminator: "")
        }

        print("")
    }

    static func error(_ items: Any...) {
        print("[ERROR] ", terminator: "")

        for item in items {
            print(item, terminator: "")
        }

        print("")
    }
}
