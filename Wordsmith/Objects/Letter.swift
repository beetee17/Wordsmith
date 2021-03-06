//
//  Letter.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI

class Letter: Identifiable {
    var char: Character { Character(string) }
    var string: String
    var color: Color? = nil
    var id = UUID()
    var isHint: Bool
    
    init(_ letter: String, color: Color? = nil, isHint: Bool = false) {
        self.string = letter.lowercased()
        self.color = color
        self.isHint = isHint
    }
}

extension Array where Element == Letter {
    func setColor(for wordle: String) {
        guard self.count == 5 else { return }
      
        var lettersLeft = [String]()
        let wordle = wordle.reduce(into: Array<String>()) { (res, letter) in
            res.append(String(letter))
            lettersLeft.append(String(letter))
            
        }

        for index in self.indices {
            let letter = self[index].string
            
            if letter == wordle[index] {
                self[index].color = .PERFECT
    
                if let searchResult = lettersLeft.firstIndex(of: letter) {
                    lettersLeft.remove(at: searchResult)
                }
                
            } else if wordle.contains(letter) {
                self[index].color = .ALMOST
            } else {
                self[index].color = .WRONG
            }
        }
        
        for index in self.indices {
            let letter = self[index]
            
            if letter.color == .ALMOST && !lettersLeft.contains(letter.string) {
                letter.color = .WRONG
            }
        }
        
    }
}
