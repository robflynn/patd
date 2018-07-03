//
//  Container.swift
//  patd
//
//  Created by Rob Flynn on 7/2/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

protocol ContainerDelegate {
    var interiorDescription: String { get }
    
    func container(didAcceptItem item: Item)
    func container(didRemoveItem item: Item)
}

protocol Container where Self:ContainerDelegate {
    var items: [Item] { get set }
    var isContainer: Bool { get }

    func add(item: Item)
    func remove(item: Item)
    func contains(item: Item) -> Bool
}

