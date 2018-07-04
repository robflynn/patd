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

class Item: GameObject, Openable, Lockable, Container, Readable, OpenableItemDelegate, LockableItemDelegate, ContainerDelegate {
    enum Trait: String {
        case Openable = "openable"
        case Gettable = "gettable"
        case Lockable = "lockable"
        case Renderable = "renderable"
        case Container = "container"
        case Readable = "readable"
    }

    var name: String
    var description: String?
    var environmentalText: String?

    internal var traits: [Item.Trait] = [] 

    // MARK: Item Property Helpers
    var isGettable: Bool {
        return self.traits.contains(.Gettable)
    }

    var isRenderable: Bool {
        return self.traits.contains(.Renderable)
    }

    var nameWithQuantity: String {
        var article: String = "a"

        if ["a", "e", "i", "o", "u"].contains(self.name.lowercased().characters.first) {
            article = "an"
        }

        return self.nameWithArticle(article: article)
    }

    init(name: String) {
        self.name = name

        super.init()

        self.description = "There's nothing special about it."
        
        // Set some default properties

        // Environment-influencing objects have to say something, otherwise what's the point in setting the
        // trait. Seeing this where it doesn't belong should be enough reminder.
        self.environmentalText = "\(self.nameWithArticle(article: "A")) is here"

        // Everything can be looked at
        self.add(intent: ExamineItemIntent(item: self))

        // Gettable
        self.add(intent: GetItemIntent(item: self))
        self.add(intent: DropItemIntent(item: self))

        // Lockable
        self.lockableDelegate = self
        self.add(intent: UnlockItemIntent(item: self))
        
        // Openable
        self.openableDelegate = self
        self.add(intent: OpenItemIntent(item: self))
        self.add(intent: CloseItemIntent(item: self))

        // Container
        self.add(intent: LookInsideItemIntent(item: self))
    }
    
    convenience init(name: String, properties: [Item.Trait]) {
        self.init(name: name)

        self.traits = properties
    }

    convenience init(name: String, description: String, properties: [Item.Trait]) {
        self.init(name: name)

        self.traits = properties
        self.description = description
    }

    convenience init(name: String, description: String) {
        self.init(name: name)

        self.description = description
    }
    
    func add(trait: Item.Trait) {
        self.traits.append(trait)
    }

    func nameWithArticle(article: String = "the") -> String {
        return "\(article) \(self.name)"
    }

    func isInteriorVisible() -> Bool {
        if isContainer && isOpenable && isOpen { return true }
        if isContainer && isOpen && isClosed { return false }
        if isContainer { return true }

        return false
    }

    // MARK: Intents
    internal var intents: [Intent] = []

    func registeredIntents() -> [Intent] {
        return self.intents
    }

    func add(intent: Intent) {
        self.intents.append(intent)
    }

    func remove(intent: Intent) {
        if let index = self.intents.index(of: intent) {
            self.intents.remove(at: index)
        }
    }

    // MARK: Renderable
    func render() {
        if let text = self.environmentalText {
            Game.shared.display(text)
        }
    }

    // MARK: Readable
    var isReadable: Bool {
        return self.traits.contains(.Readable)
    }

    var readableText: String?

    func read() -> Bool {
        if !isReadable {
            Game.shared.display("You can't read \(self.nameWithArticle())")

            return false
        }

        guard let text = self.readableText else {
            Logger.error("Readable item with no readable text and no override!")
            
            return false
        }

        Game.shared.display(text)

        return true
    }

    // MARK: Examine
    func examine() -> Bool {
        var lines: [String] = []

        // An item will first show it's description if it has one
        if let descriptionText = self.description {
            lines.append(descriptionText)
        }

        // Let the user know if an item is openable
        if isOpenable {
            lines.append("It is \(self.isOpen ? "open" : "closed").")
        }

        // If we don't have anything to say, just say something generic
        if lines.isEmpty {
            lines.append("You see nothing special about \(self.nameWithArticle()).")
        }

        let message = lines.joined(separator: " ")
        Game.shared.display(message)

        return true
    }
    
    // MARK: Openable
    var openState: OpenState = .Closed
    var openableDelegate: OpenableItemDelegate?
    var isOpenable: Bool { return self.traits.contains(.Openable) }
    var isClosable: Bool { return self.traits.contains(.Openable) }

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
    var isLockable: Bool { return self.traits.contains(.Lockable) }
    var isUnlockable: Bool { return self.traits.contains(.Lockable) }

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
        return self.traits.contains(.Container)
    }

    var interiorDescription: String {
        if (isContainer && isInteriorVisible()) {
            if self.items.isEmpty {
                return "It's empty."
            }

            return "You see " + self.items.map { $0.nameWithArticle(article: "a") }.joined(separator: ", ")
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
            // FIXME: We don't want to assume that removing will always succeed
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
