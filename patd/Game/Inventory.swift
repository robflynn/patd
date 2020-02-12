//
//  Inventory.swift
//  patd
//
//  Created by Rob Flynn on 2/11/20.
//  Copyright © 2020 Thingerly. All rights reserved.
//

class Inventory {
    internal var _inventory: [Item: Int] = [Item: Int]()
    
    var isEmpty: Bool {
        get {
            return items.isEmpty
        }
    }
    
    var items: [Item] {
        get {
            return _inventory.keys.map { return $0 } as [Item]
        }
    }
    
    func add(_ item: Item) -> Item? {
        return add(item, count: 1)
    }
    
    func add(_ item: Item, count: Int) -> Item? {
        if let countInBag = _inventory[item] {
            _inventory[item] = countInBag + count
        } else {
            _inventory[item] = count
        }
        
        return item
    }
    
    func remove(_ item: Item) -> Item? {
        return remove(item, count: 1)
    }
    
    func remove(_ item: Item, count: Int) -> Item? {
        if contains(item, count: count) {
            decrement(item: item, by: count)
        }
        
        return item
    }
    
    func contains(_ item: Item) -> Bool {
        return contains(item, count: 1)
    }
    
    func contains(_ item: Item, count: Int) -> Bool {
        guard let _ = _inventory[item] else { return false }
        
        return true
    }
        
    // MARK: - Helpers
    private func decrement(item: Item, by amountToDecrement: Int) {
        if let count = _inventory[item] {
            let newAmount = count - amountToDecrement
            
            _inventory[item] = newAmount
            
            if newAmount <= 0 {
                _inventory.removeValue(forKey: item)
            }
        }
    }
    
    private func increment(item: Item, by amountToIncrement: Int) {
        if let count = _inventory[item] {
            _inventory[item] = count + amountToIncrement
        }
    }

}
