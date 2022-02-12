//
//  WordleViewModel.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI
import CoreData

class WordSmithViewModel: ObservableObject {
    @Published var game: Game
    @Published var attempts: [[Letter]]
    @Published var currentAttempt: [Letter?]
    @Published var answers: [String]
    
    @Published var selection = 0
    @Published var lastEditAction: EditAction = .None
    
    @Published var answer: String
    @Published var hint: (Int, String)? = nil
    
    @Published var definitionToShow = ""
    @Published var showDefinition = false
    @Published var showLeaderboards = false
    
    init() {
        var res = moc.safeFetch(Game.fetchRequest(), NSPredicate(format: "numLetters_ == %d", 5)).first
        if let res = res {
            self.game = res
        } else {
            PersistenceController.initCoreData()
            res = moc.safeFetch(Game.fetchRequest(), NSPredicate(format: "numLetters_ == %d", 5)).first!
            self.game = moc.safeFetch(Game.fetchRequest(), NSPredicate(format: "numLetters_ == %d", 5)).first!
        }
        
        self.attempts = []
        self.currentAttempt = Array(repeating: nil, count: res!.numLetters)
        
        let answers = loadWords("\(res!.numLetters)answers")
        self.answers = answers
        self.answer = answers.randomElement()!
    }
    
    func setGame(_ game: Game) {
        self.game = game
        self.answers = loadWords("\(game.numLetters)answers")
        self.reset()
    }
    
    static func preview(numLetters: Int = 5) -> WordSmithViewModel{
        let vm = WordSmithViewModel()
        vm.setGame(moc_preview.safeFetch(Game.fetchRequest(), NSPredicate(format: "numLetters_ == %d", numLetters)).first!)
        if numLetters == 5 {
            let answer = "black"
            vm.answer = answer
            vm.attempts = [.init("rates", answer: answer),
                           .init("allow", answer: answer),
                           .init("pluck", answer: answer),
                           .init("black", answer: answer)]
            for attempt in vm.attempts {
                Keyboard.shared.updateColors(for: attempt)
            }
            
        } else if numLetters == 6 {
            let answer = "broken"
            vm.answer = answer
            vm.attempts = [.init("create", answer: answer),
                           .init("driver", answer: answer),
                           .init("breath", answer: answer),
                           .init("spoken", answer: answer),
                           .init("broken", answer: answer)]
            for attempt in vm.attempts {
                Keyboard.shared.updateColors(for: attempt)
            }

        } else if numLetters == 7 {
            let answer = "digital"
            vm.answer = answer
            vm.attempts = [.init("failing", answer: answer),
                           .init("billion", answer: answer),
                           .init("desktop", answer: answer),
                           .init("digital", answer: answer)]
            for attempt in vm.attempts {
                Keyboard.shared.updateColors(for: attempt)
            }
        }
        
        vm.selection = -1
        return vm
    }
    
    func updateSelection(to newValue: Int, action: EditAction) {
        guard newValue >= 0 && newValue < game.numLetters else {
            lastEditAction = action
            return
        }
        
        
        if action == lastEditAction { selection = newValue }
        else if action == .None { selection = newValue }
        
        lastEditAction = action
    }
    
    func incrementSelection() {
        if lastEditAction == .Insert {
            selection = min(selection+2, game.numLetters - 1)
        } else {
            selection = min(selection+1, game.numLetters - 1)
        }
        lastEditAction = .None
    }
    
    func addChar(_ char: Letter) {
        // TODO: Make selection look like it moves to next blank cell
        updateSelection(to: selection+1, action: .Insert)
        currentAttempt[selection] = char
        
    }
    
    func deleteChar() {
        updateSelection(to: selection-1, action: .Delete)
        currentAttempt[selection] = nil
    }
    
    func surrender() {
        
        let alertTitle = "Give Up"
        let alertMessage = "Are you sure you want to skip this word? Your current streak will be lost."
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            ErrorViewModel.shared.alertIsShown = false
            self.showPlayerLostAlert()
        }
        
        ErrorViewModel.shared.showAlert(alertTitle, alertMessage, [confirmAction, cancelButton(title: "Cancel", { })])
    }
    
    func confirmAttempt() {
        let currentAttempt = currentAttempt.compactMap({$0})
        guard currentAttempt.count == game.numLetters else { return }
        guard isWord(currentAttempt) else { return }
            
        currentAttempt.setColor(for: answer, numLetters: game.numLetters)
        Keyboard.shared.updateColors(for: currentAttempt)
        attempts.append(currentAttempt)
        game.updateGuessHistory(with: currentAttempt.toString())
        
        if isCorrect(currentAttempt) {
            showPlayerWonAlert()
            
        } else if attempts.count >= Global.maxAttempts {
            // Player is out of attempts
            showPlayerLostAlert()
        }
        
        self.currentAttempt = Array(repeating: nil, count: game.numLetters)
        self.updateSelection(to: 0, action: .None)
    }
    
    func isWord(_ word: [Letter]) -> Bool {
        let word = word.toString()
        guard Global.dictionary.search(element: word) != -1 else {
            ErrorViewModel.shared.showBanner(title: "Invalid Attempt",
                                             message: "\(word.capitalized) is not a word!")
            return false
        }
        
        return true
    }
    
    func isCorrect(_ word: [Letter]) -> Bool {
        // check if valid word
        print("CORRECT")
        return word.toString() == answer
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
        let hint = String(answer[randIndex])
        
        currentAttempt[randIndex] = Letter(hint, isHint: true)
        self.hint = (randIndex, hint)
        
    }
    
    func reset() {
        currentAttempt = Array(repeating: nil, count: game.numLetters)
        attempts = []
        hint = nil
        Keyboard.shared.reset()
        selection = 0
        lastEditAction = .None
        answer = answers.randomElement()!
    }
}

// MARK: - Alert Handling
extension WordSmithViewModel {
    
    func definitionAction(_ completion: @escaping () -> Void) -> UIAlertAction {
        return UIAlertAction(title: "Lookup '\(self.answer.capitalized)'", style: .default) { (action) in
            self.definitionToShow = self.answer
            self.showDefinition = true
            completion()
            ErrorViewModel.shared.alertIsShown = false
        }
        
    }
    
    func leaderboardAction(_ completion: @escaping () -> Void) -> UIAlertAction {
        return UIAlertAction(title: "View Leaderboards", style: .default) { (action) in
            self.showLeaderboards = true
            completion()
            ErrorViewModel.shared.alertIsShown = false
        }
    }
    
    func cancelButton(title: String = "Continue", _ completion: @escaping () -> Void) -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel) { (action) in
            completion()
            ErrorViewModel.shared.alertIsShown = false
        }
    }
    
    func showPlayerWonAlert() {
        let alertTitle = "WELL DONE"
        let alertMessage = "\n\(answer.capitalized) found in \(attempts.count) turn(s)"
        
        let cancelAction =  { [self] in
            game.incrementNumPlayed()
            game.incrementNumGuesses(for: attempts.count)
            game.incrementCurrStreak()
            reset()
        }
     
        ErrorViewModel.shared.showAlert(alertTitle, alertMessage, [definitionAction(cancelAction), leaderboardAction(cancelAction), cancelButton(cancelAction)])
    }
    
    func showPlayerLostAlert() {
        // Player is out of attempts
        let alertTitle = "STREAK LOST"
        let alertMessage = "\nPrevious Best: \(game.prevBest) \n\nThe word was \(answer.capitalized)"
        
        let cancelAction = { [self] in
            game.incrementNumPlayed()
            game.resetCurrStreak()
            reset()
        }
        
        ErrorViewModel.shared.showAlert(alertTitle, alertMessage, [definitionAction(cancelAction), leaderboardAction(cancelAction), cancelButton(cancelAction)])
    }
    
}
