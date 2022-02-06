//
//  Keyboard.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI

class Keyboard: ObservableObject {
    static var shared = Keyboard()
    
    var letters = "QWERTYUIOPASDFGHJKLZXCVBNM".reduce(into: []) { (res, letter) in
        res.append(Letter(String(letter), color: .KEYBOARD))
    }
    
    var topRow: ArraySlice<Letter> { letters[0..<10] }
    var middleRow: ArraySlice<Letter> { letters[10..<19] }
    var bottomRow: ArraySlice<Letter> { letters[19..<26] }
    
    func updateColors(for attempt: [Letter]) {
        for letter in attempt {
            let keyBoardButton = letters.first(where: { $0.string == letter.string })!
            keyBoardButton.color = Color.max(keyBoardButton.color!, letter.color ?? .KEYBOARD)
        }
    }
    
    func reset() {
        for letter in letters {
            letter.color = .KEYBOARD
        }
    }
    
}
