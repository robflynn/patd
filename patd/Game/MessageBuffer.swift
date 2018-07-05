//
//  MessageBuffer.swift
//  patd
//
//  Created by Rob Flynn on 7/4/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

class MessageBuffer {
    private var _buffer = String()

    var isEmpty: Bool {
        return _buffer.isEmpty
    }

    func clear() {
        self._buffer = String()
    }

    func send(_ message: String, noReturn: Bool = false) {
        self._buffer.append(message)

        if (!noReturn) {
            self._buffer.append("\n")
        }
    }

    func flush() -> String {
        defer {
            self.clear()
        }

        return self._buffer
    }

    func newLine() {
        self.send("")
    }
}
