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
    
    convenience init(context: NSManagedObjectContext,
                     currStreak: Int = 0,
                     prevBest: Int = 0,
                     numPlayed: Int = 0,
                     numLetters: Int = 5,
                     numGuesses: [String:Int]? = nil,
                     guessHistory: [String:Int] = [:]) {
        self.init(context: context)
        self.currStreak = currStreak
        self.prevBest = prevBest
        self.numPlayed = numPlayed
        self.numLetters = numLetters
        
        let numGuesses = numGuesses ?? ["1" : 0, "2" : 0, "3" : 0, "4" : 0, "5" : 0, "6" : 0]
        
        for item in numGuesses {
            let keyValuePair = KeyValuePair(context: context)
            keyValuePair.key = item.key
            keyValuePair.value = item.value
            
            self.addToNumGuesses_(keyValuePair)
        }
        
        for item in guessHistory {
            let keyValuePair = KeyValuePair(context: context)
            keyValuePair.key = item.key
            keyValuePair.value = item.value
            
            self.addToNumGuesses_(keyValuePair)
        }
        
    }
    
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
        
        return array.sorted() { $0.value > $1.value }
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
    func getGuessDistribution() -> [String : Int] {
        return numGuesses.reduce(into: [String:Int](), { (res, nextVal) in
            res[nextVal.key] = nextVal.value
        })
    }
    
    func getGuessHistory() -> [String] {
        var hist = [String]()
        for i in 0..<min(5, guessHistory.count) {
            hist.append(guessHistory[i].key)
        }
        return hist
    }
    
    func incrementNumPlayed() {
        numPlayed += 1
        moc.safeSave()
    }
    
    func incrementCurrStreak() {
        currStreak += 1
        prevBest = max(prevBest, currStreak)
        GameCenter.submitScore(of: prevBest, to: .LongestStreak)
        moc.safeSave()
    }
    func resetCurrStreak() {
        currStreak = 0
        moc.safeSave()
    }
    
    func incrementNumGuesses(for index: Int) {
        numGuesses[index-1].value += 1
        moc.safeSave()
    }
    func updateGuessHistory(with guess: String) {
        let item = guessHistory.first(where: { $0.key == guess})
        if let item = item {
            item.value += 1
        } else {
            let newItem = KeyValuePair(context: moc, key: guess, value: 1)
            self.addToGuessHistory_(newItem)
        }
    }
}
