//
//  Array+listified.swift
//  patd
//
//  Created by Rob Flynn on 7/4/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

extension Array where Element: Item {
    func listified() -> String {
        var chunks: [String] = []

        for item in self {
            chunks.append(item.nameWithQuantity)
        }

        if chunks.count < 2 {
            return chunks.joined()
        }

        if chunks.count == 2 {
            return chunks.joined(separator: " and ")
        }

        let last = chunks.popLast()!

        return chunks.joined(separator: ", ") + ", and \(last)"
    }
}
