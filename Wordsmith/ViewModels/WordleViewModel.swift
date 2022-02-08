//
//  WordleViewModel.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI

class WordleViewModel: ObservableObject {
    
    @Published var attempts: [[Letter]] = []
    @Published var currentAttempt: [Letter?] = Array(repeating: nil, count: Game.numLetters)
    
    @Published var selection = 0
    @Published var lastEditAction: EditAction = .None
    
    @Published var wordle: String = Game.wordles.randomElement()!
    @Published var hint: (Int, String)? = nil
    
    static var preview: WordleViewModel {
        let vm = WordleViewModel()
        let wordle = "black"
        vm.wordle = wordle
        vm.attempts = [.init("rates", wordle: wordle),
                       .init("allow", wordle: wordle),
                       .init("pluck", wordle: wordle),
                       .init("black", wordle: wordle)]
        vm.selection = -1
        return vm
    }
    
    var currentStreak = Player.currStreak {
        didSet {
            UserDefaults.standard.set(currentStreak, forKey: "Current Win Streak")
        }
    }
    
    var previousBest = Player.bestStreak {
        didSet {
            UserDefaults.standard.set(previousBest, forKey: "Previous Best")
            GameCenter.submitScore(of: previousBest, to: .LongestStreak)
        }
    }
    
    func updateSelection(to newValue: Int, action: EditAction) {
        guard newValue >= 0 && newValue < Game.numLetters else {
            lastEditAction = action
            return
        }
        
        
        if action == lastEditAction { selection = newValue }
        else if action == .None { selection = newValue }
        
        lastEditAction = action
    }
    
    func incrementSelection() {
        if lastEditAction == .Insert {
            selection = min(selection+2, Game.numLetters)
        } else {
            selection = min(selection+1, Game.numLetters)
        }
        lastEditAction = .None
    }
    
    func addChar(_ char: Letter) {
        updateSelection(to: selection+1, action: .Insert)
        currentAttempt[selection] = char
        
    }
    
    func deleteChar() {
        updateSelection(to: selection-1, action: .Delete)
        currentAttempt[selection] = nil
    }
    
    func surrender() {
        let alertTitle = "STREAK LOST"
        let alertMessage = "\nPrevious Best: \(previousBest) \n\nThe word was \(wordle.capitalized)"
        ErrorViewModel.shared.showAlert(alertTitle, alertMessage) {
            Player.incrementNumPlayed()
            self.currentStreak = 0
            self.reset()
            
        }
    
        self.currentAttempt = Array(repeating: nil, count: Game.numLetters)
        self.updateSelection(to: 0, action: .None)

    }
    
    func confirmAttempt() {
        let currentAttempt = currentAttempt.compactMap({$0})
        guard currentAttempt.count == Game.numLetters else { return }
        guard isWord(currentAttempt) else { return }
            
        currentAttempt.setColor(for: wordle)
        Keyboard.shared.updateColors(for: currentAttempt)
        attempts.append(currentAttempt)
        Player.updateGuesses(with: currentAttempt.toString())
        
        if isCorrect(currentAttempt) {
            let alertTitle = "WELL DONE"
            let alertMessage = "\n\(wordle.capitalized) found in \(attempts.count) turns"
            
            ErrorViewModel.shared.showAlert(alertTitle, alertMessage) {
                Player.incrementNumPlayed()
                Player.updateGuessDistribution(with: self.attempts.count)
                self.currentStreak += 1
                self.reset()
                
            }
            
            
        } else if attempts.count >= Game.maxAttempts {
            // Player is out of attempts
            let alertTitle = "STREAK LOST"
            let alertMessage = "\nPrevious Best: \(previousBest) \n\nThe word was \(wordle.capitalized)"
            ErrorViewModel.shared.showAlert(alertTitle, alertMessage) {
                Player.incrementNumPlayed()
                self.currentStreak = 0
                self.reset()
                
            }
        }
        
        self.currentAttempt = Array(repeating: nil, count: Game.numLetters)
        self.updateSelection(to: 0, action: .None)
    }
    
    func isWord(_ word: [Letter]) -> Bool {
        let word = word.toString()
        guard Game.dictionary.search(element: word) != -1 else {
            ErrorViewModel.shared.showBanner(title: "Invalid Attempt",
                                             message: "\(word.capitalized) is not a word!")
            return false
        }
        
        return true
    }
    
    func isCorrect(_ word: [Letter]) -> Bool {
        // check if valid word
        print("CORRECT")
        return word.toString() == wordle
    }
    
    func getHint() {
        if let hint = self.hint {
            currentAttempt[hint.0] = Letter(hint.1, isHint: true)
            return
        }
        // look through past attempts to see which letters are still needed
        var uselessHints = Set<Int>()
        for attempt in attempts {
            for (index, letter) in Array(zip(attempt.indices, attempt)) {
                if letter.color == .PERFECT {
                    uselessHints.insert(index)
                }
            }
        }
        
        let usefulHints = Set(0...4).subtracting(uselessHints)
        
        // randomly choose one of them and insert into current attempt
        let randIndex = usefulHints.randomElement()!
        let hint = String(wordle[randIndex])
        
        currentAttempt[randIndex] = Letter(hint, isHint: true)
        self.hint = (randIndex, hint)
        
    }
    
    func reset() {
        currentAttempt = Array(repeating: nil, count: Game.numLetters)
        attempts = []
        hint = nil
        Keyboard.shared.reset()
        wordle = Game.wordles.randomElement()!
        previousBest = max(previousBest, currentStreak)
    }
}
