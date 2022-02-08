//
//  Wordsmith_App.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

let defaults = UserDefaults.standard
var window = UIApplication.shared.windows.first

@main
struct Wordle_CloneApp: App {
//    let viewModel = WordleViewModel.preview
    let viewModel = WordleViewModel()
    @ObservedObject var errorHandler = ErrorViewModel.shared
    
    init() {
        // register "default defaults"
        
        defaults.register(defaults: [
            "Current Win Streak" : 0,
            "Previous Best" : 0,
            "Num Played" : 0,
            "Num Guesses History" : ["1" : 0, "2" : 0, "3" : 0, "4" : 0, "5" : 0, "6" : 0],
            "Guess History" : [String : Int]()
            // ... other settings
        ])
//        defaults.register(defaults: [
//            "Current Win Streak" : 10,
//            "Previous Best" : 22,
//            "Num Played" : 40,
//            "Num Guesses History" : ["1" : 0, "2" : 2, "3" : 7, "4" : 10, "5" : 13, "6" : 8],
////            "Guess History" : [String : Int]()
//            "Guess History" : ["rates" : 20, "great" : 10, "arise" : 5, "champ" : 3, "wordy" : 1]
//            // ... other settings
//        ])
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(errorHandler)
                .onAppear { GameCenter.authenticateUser() }
        }
    }
}
