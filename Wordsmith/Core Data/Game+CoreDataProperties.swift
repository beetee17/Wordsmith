//
//  Game+CoreDataProperties.swift
//  Wordsmith
//
//  Created by Brandon Thio on 12/2/22.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var currStreak_: Int32
    @NSManaged public var prevBest_: Int32
    @NSManaged public var numPlayed_: Int32
    @NSManaged public var numLetters_: Int32
    @NSManaged public var numGuesses_: NSSet?
    @NSManaged public var guessHistory_: NSSet?
    
    var currStreak: Int {
        get {
            return Int(currStreak_)
        }
        set {
            currStreak_ = Int32(newValue)
        }
    }
    var prevBest: Int {
        get {
            return Int(prevBest_)
        }
        set {
            prevBest_ = Int32(newValue)
        }
    }
    var numPlayed: Int {
        get {
            return Int(numPlayed_)
        }
        set {
            numPlayed_ = Int32(newValue)
        }
    }
    var numLetters: Int {
        get {
            return Int(numLetters_)
        }
        set {
            numLetters_ = Int32(newValue)
        }
    }
    var numGuesses: [KeyValuePair] {
        let array = numGuesses_ as? Set<KeyValuePair> ?? []
        
        return array.sorted() { $0.key < $1.key }
    }
    
    var guessHistory: [KeyValuePair] {
        let array = guessHistory_ as? Set<KeyValuePair> ?? []
        
        return array.sorted() { $0.value < $1.value }
    }

}

// MARK: Generated accessors for numGuesses_
extension Game {

    @objc(addNumGuesses_Object:)
    @NSManaged public func addToNumGuesses_(_ value: KeyValuePair)

    @objc(removeNumGuesses_Object:)
    @NSManaged public func removeFromNumGuesses_(_ value: KeyValuePair)

    @objc(addNumGuesses_:)
    @NSManaged public func addToNumGuesses_(_ values: NSSet)

    @objc(removeNumGuesses_:)
    @NSManaged public func removeFromNumGuesses_(_ values: NSSet)

}

// MARK: Generated accessors for guessHistory_
extension Game {

    @objc(addGuessHistory_Object:)
    @NSManaged public func addToGuessHistory_(_ value: KeyValuePair)

    @objc(removeGuessHistory_Object:)
    @NSManaged public func removeFromGuessHistory_(_ value: KeyValuePair)

    @objc(addGuessHistory_:)
    @NSManaged public func addToGuessHistory_(_ values: NSSet)

    @objc(removeGuessHistory_:)
    @NSManaged public func removeFromGuessHistory_(_ values: NSSet)

}

extension Game : Identifiable {

}
