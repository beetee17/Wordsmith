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
    @NSManaged public var numLetters: Int32
    @NSManaged public var numGuesses_: NSSet?
    @NSManaged public var guessHistory_: NSSet?

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
