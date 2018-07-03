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
    func item(didLock item: Item)
}

protocol OpenableItemDelegate {
    func item(didOpen item: Item)
    func item(didClose item: Item)
}

class Item: GameObject, Openable, Lockable, Container, OpenableItemDelegate, LockableItemDelegate, ContainerDelegate {
    enum Property {
        case Openable
        case Gettable
        case Lockable
        case Renderable
        case Container
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
                blurbs.append("You see nothing special about the \(self.name).")
            }
            
            if self.isOpenable {
                blurbs.append("It is \(self.isOpen ? "open" : "closed").")
            }
            
            return blurbs.joined(separator: " ")
        }
    }
    var renderText: String?
    
    private var _description: String?

    var intents: [Intent] {
        return _intents
    }

    internal var _intents: [Intent] = []
    internal(set) var properties: [Item.Property] = [] {
        didSet {
            print("==> Prop was set")
            print(properties)
        }
    }
    
    // MARK: Item Property Helpers
    var isGettable: Bool {
        return self.properties.contains(.Gettable)
    }

    var isRenderable: Bool {
        return self.properties.contains(.Renderable)
    }

    init(name: String) {
        self.name = name

        super.init()
        
        self._intents.append(ExamineItemIntent(item: self))
        self._intents.append(GetItemIntent(item: self))
        self._intents.append(DropItemIntent(item: self))

        // Lockable
        self.lockableDelegate = self
        self._intents.append(UnlockItemIntent(item: self))
        
        // Openable
        self.openableDelegate = self
        self._intents.append(OpenItemIntent(item: self))
        self._intents.append(CloseItemIntent(item: self))

        // Container
        self._intents.append(LookInsideItemIntent(item: self))
    }

    convenience init(name: String, properties: [Item.Property]) {
        self.init(name: name)

        self.properties = properties
    }

    convenience init(name: String, description: String, properties: [Item.Property]) {
        self.init(name: name, properties: properties)

        self._description = description
    }

    convenience init(name: String, description: String) {
        self.init(name: name)

        self.description = description
    }

    func named(article: String = "the") -> String {
        return "\(article) \(self.name)"
    }

    func isInteriorVisible() -> Bool {
        if isContainer {
            if isOpenable {
                if isOpen {
                    return true
                }

                return false
            }

            return true
        }

        return false
    }

    func add(intent: Intent) {
        self._intents.append(intent)
    }

    // MARK: Renderable
    func render() {
        if let text = self.renderText {
            Game.shared.display(text)
        }
    }
    
    // MARK: Openable
    var openState: OpenState = .Closed
    var openableDelegate: OpenableItemDelegate?
    var isOpenable: Bool { return self.properties.contains(.Openable) }
    var isClosable: Bool { return self.properties.contains(.Openable) }

    func open() -> Bool {
        // By default, items cannot be opened
        if !self.isOpenable { Game.shared.display("You cannot open the \(self.name)"); return false }
        
        // If it's open, you can't open it more
        if self.isOpen { Game.shared.display("It is already open."); return false }
        
        // And you can't open things that are locked
        if self.isLocked { Game.shared.display("It is locked."); return false  }

        self.openState = .Open
        
        self.openableDelegate?.item(didOpen: self)
        
        return true
    }
    
    func close() -> Bool {
        // FIXME: I feel like we should handle this differently
        if !self.isClosable { Game.shared.display("You cannot close the \(self.name)"); return false }
        
        if self.isClosed { Game.shared.display("It is already closed."); return false}
        
        self.openState = .Closed
        
        self.openableDelegate?.item(didClose: self)
        
        return true
    }
    
    func item(didOpen item: Item) {
        Game.shared.display("You open the \(item.name).")
    }
    
    func item(didClose item: Item) {
        Game.shared.display("You close the \(item.name).")
    }
    
    // MARK: Lockable
    var lockState: LockState = .Unlocked
    var lockableDelegate: LockableItemDelegate?
    var isLockable: Bool { return self.properties.contains(.Lockable) }
    var isUnlockable: Bool { return self.properties.contains(.Lockable) }

    func lock() -> Bool {
        if !self.isLockable { Game.shared.display("The \(self.name) doesn't have a lock."); return false }
        if self.isLocked { Game.shared.display("It is already locked."); return false }

        self.lockState = .Locked

        self.lockableDelegate?.item(didLock: self)

        return true
    }

    func unlock() -> Bool {
        if !self.isLockable { Game.shared.display("The \(self.name) doesn't have a lock."); return false }

        if !self.isLocked { Game.shared.display("It is already unlocked."); return false }

        self.lockState = .Unlocked

        self.lockableDelegate?.item(didUnlock: self)
        
        return true
    }
    
    func item(didUnlock item: Item) {
        Game.shared.display("You unlock the \(item.name).")
    }

    func item(didLock item: Item) {
        Game.shared.display("You lock the \(item.name)")
    }

    // MARK: Container
    var items: [Item] = []
    var containerDelegate: ContainerDelegate?

    var isContainer: Bool {
        return self.properties.contains(.Container)
    }

    var interiorDescription: String {
        if (isContainer && isInteriorVisible()) {
            if self.items.isEmpty {
                return "It's empty."
            }

            return "You see " + self.items.map { $0.named(article: "a") }.joined(separator: ", ")
        }

        return "You can't see inside it."
    }

    func add(item: Item) {
        if isContainer {
            self.items.append(item)

            self.containerDelegate?.container(didAcceptItem: item)
        } else {
            Game.shared.display("You can't put that there")
        }
    }

    func remove(item: Item) {
        if let index = self.items.index(of: item) {
            self.items.remove(at: index)

            self.containerDelegate?.container(didRemoveItem: item)
        } else {
            // FIXME:
            Game.shared.display("------> DOES THIS SHOW UP, REMEMBER ME")
        }
    }

    func contains(item: Item) -> Bool {
        return self.items.contains(item)
    }

    func container(didAcceptItem item: Item) {
        Game.shared.display("You put the \(item.name) in the \(self.name).")
    }

    func container(didRemoveItem item: Item) {
    }
}
