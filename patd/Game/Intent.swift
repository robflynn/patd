//
//  Intent.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

// This intent system is going to be very basic for now
protocol Intent {    
    var triggers: [String] { get }

    func execute() -> Bool
}
