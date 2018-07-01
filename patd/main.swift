//
//  main.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

func display(_ message: String) {
    print(message)
}

func display(_ message: String, noReturn: Bool) {
    if noReturn {
        print(message, terminator: "")
    } else {
        display(message)
    }
}

func getUserInput() -> String? {
    display("> ", noReturn: true)

    let input = readLine()

    return input
}

let game = Game()

display("Hello World")

let input = getUserInput()
