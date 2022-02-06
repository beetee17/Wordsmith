//
//  Defaults.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI

struct Device {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

struct Game {
    static let dictionary = loadWords("words")
    static let wordles = loadWords("wordles")
    static let maxAttempts = 6
    static let numLetters = 5
    
}

struct Player {
    static var numPlayed: Int {
        defaults.integer(forKey: "Num Played")
    }
    static var currStreak: Int {
        defaults.integer(forKey: "Current Win Streak")
    }
    static var bestStreak: Int {
        defaults.integer(forKey: "Previous Best")
    }
    
    static var guessHistory: [String : Int] {
        guard let dict = defaults.object(forKey: "Guess History") as? [String : Int] else {
            print("Guess history not found")
            return [String:Int]()
        }
        return dict
    }
    static var guessDistribution: [String : Int] {
        guard let dict = defaults.object(forKey: "Num Guesses History") as? [String : Int] else {
            print("Guess distribution not found")
            return [String:Int]()
        }
        return dict
    }
    
    static func updateGuesses(with guess: String) {
        var dict = Player.guessHistory
        
        if let value = dict[guess] {
            dict.updateValue(value+1, forKey: guess)
        } else {
            print("Did not find \(guess) in \(dict)")
            dict.updateValue(1, forKey: guess)
        }
        defaults.set(dict, forKey: "Guess History")
        print("Updated key \(guess) to value \(dict[guess])")
    }
    static func incrementNumPlayed() {
        defaults.set(Player.numPlayed+1, forKey: "Num Played")
    }
    
    static func updateGuessDistribution(with numGuesses: Int) {
        var dict = Player.guessDistribution
        
        let key = "\(numGuesses)"
        
        if let value = dict[key] {
            dict.updateValue(value+1, forKey: key)
        } else {
            dict.updateValue(1, forKey: key)
        }
        defaults.set(dict, forKey: "Num Guesses History")
        print("Updated key \(key) to value \(dict[key])")
    }
    
}

// Loading of Data
func loadWords(_ filename: String) -> [String] {
    
    do {
        print("loading \(String(describing: filename))")
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
            print("no path found")
            return []
        }
        
        let words = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: "\n")
        
        return words
        
    } catch {
        print(error.localizedDescription)
    }
    return []
}
