//
//  Item.swift
//  patd
//
//  Created by Rob Flynn on 7/1/18.
//  Copyright © 2018 Thingerly. All rights reserved.
//

import Foundation

protocol LockableItemDelegate {
    func item(didUnlock item: Item)
}

protocol OpenableItemDelegate {
    func item(didOpen item: Item)
    func item(didClose item: Item)
}

class Item: GameObject, Openable, OpenableItemDelegate, LockableItemDelegate {
    enum Property {
        case Openable
        case Gettable
        case Lockable
        case Renderable
    }

    var name: String
    var description: String {
        set {
            self._description = newValue
        }
        
        get {
            var blurbs: [String] = []
            
            if let desc = self._description {
                blurbs.append(desc)
            } else {
                blurbs.append("I see nothing special about the \(self.name).")
            }
            
            if self.isOpenable {
                blurbs.append("It is \(self.isOpen ? "open" : "closed").")
            }
            
            return blurbs.joined(separator: " ")
        }
    }
    var renderText: String?
    
    private var _description: String?
    
    var intents: [Intent] = []
    internal(set) var properties: [Item.Property] = []
    
    var isGettable: Bool {
        return self.properties.contains(.Gettable)
    }
    
    var isOpenable: Bool {
        return self.properties.contains(.Openable)
    }
    
    var isLockable: Bool {
        return self.properties.contains(.Lockable)
    }
    
    var isRenderable: Bool {
        return self.properties.contains(.Renderable)
    }
    
    var lockableDelegate: LockableItemDelegate?
    
    var isLocked: Bool {
        didSet {
            if !self.isLockable {
                self.isLocked = false
            }
        }
    }
    
    init(name: String, properties: [Item.Property]) {
        self.name = name
        self.properties = properties
        self.isLocked = false
        
        super.init()
        
        self.intents.append(ExamineItemIntent(item: self))
        self.intents.append(GetItemIntent(item: self))
        self.intents.append(DropItemIntent(item: self))
        self.intents.append(UnlockItemIntent(item: self))
        
        // Items are responsible for opening themselves
        self.openableDelegate = self
        self.intents.append(OpenItemIntent(item: self))
        self.intents.append(CloseItemIntent(item: self))
    }
    
    convenience init(name: String, description: String, properties: [Item.Property]) {
        self.init(name: name, properties: properties)
        
        self._description = description
    }
    
    func render() {
        if let text = self.renderText {
            display(text)
        }
    }
    
    // MARK: Openable
    var openState: OpenState = .Closed
    var openableDelegate: OpenableItemDelegate?
    
    func open() -> Bool {
        // By default, items cannot be opened
        if !self.isOpenable { display("You cannot open the \(self.name)"); return false }
        
        // If it's open, you can't open it more
        if self.isOpen { display("It is already open."); return false }
        
        // And you can't open things that are locked
        if self.isLocked { display("It is locked."); return false  }

        self.openState = .Open
        
        self.openableDelegate?.item(didOpen: self)
        
        return true
    }
    
    func close() -> Bool {
        // FIXME: I feel like we should handle this differently
        if !self.isOpenable { display("You cannot close the \(self.name)"); return false }
        
        if self.isClosed { display("It is already closed."); return false}
        
        self.openState = .Closed
        
        self.openableDelegate?.item(didClose: self)
        
        return true
    }
    
    func item(didOpen item: Item) {
        display("You open the \(item.name).")
    }
    
    func item(didClose item: Item) {
        display("You close the \(item.name).")
    }
    
    // MARK: Unlockable
    func unlock() -> Bool {
        if !self.isLockable { display("You cannot unlock \(self.name)"); return false }
        if !self.isLocked { display("It is already unlocked."); return false }
        
        self.isLocked = false
        self.lockableDelegate?.item(didUnlock: self)
        
        return true
    }
    
    func item(didUnlock item: Item) {
        display("You unlock the \(item.name).")
    }
}
