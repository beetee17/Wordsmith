//
//  Wordsmith_App.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

var window = UIApplication.shared.windows.first
let moc_preview = PersistenceController.preview.container.viewContext
let moc = PersistenceController.shared.container.viewContext

@main
struct Wordle_CloneApp: App {
    let viewModel = WordSmithViewModel.preview(numLetters: 7)
//    let viewModel = WordSmithViewModel()
    @ObservedObject var errorHandler = ErrorViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(errorHandler)
                .environment(\.managedObjectContext, moc)
                .onAppear { GameCenter.authenticateUser() }
        }
    }
}
