//
//  ContentView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var viewModel: WordleViewModel
    @EnvironmentObject var errorHandler: ErrorViewModel
    
    @State private var showStats = false
    @State private var showTutorial = false
    @State private var definitionToShow = ""
    @State private var showDefinition = false
    @State private var showLeaderboards = false
    
    var body: some View {
        if showLeaderboards {
            
            GKLeaderboardView(isShowing: $showLeaderboards)
                .transition(.move(edge: .bottom))
                
        } else {
            ZStack {
                Color.accentColor.ignoresSafeArea()
                
                VStack {
                    
                    TopBar(showStats: $showStats,
                           showTutorial: $showTutorial,
                           showLeaderboards: $showLeaderboards)
                    
                    GridView()
                    
                    Spacer()
                    
                    //                HintButton()
                    
                    KeyboardView()
                }
                .opacity(showStats ? 0.2 : 1)
                
                if showStats {
                    StatisticsView(isPresented: $showStats)
                        .zIndex(1) // removal transition does not animate when zIndex is not set
                        .transition(.scale)
                }
                if showTutorial {
                    TutorialView(isPresented: $showTutorial)
                        .zIndex(1) // removal transition does not animate when zIndex is not set
                        .transition(.scale)
                }
            }
            .banner(isPresented: $errorHandler.bannerIsShown, title: errorHandler.bannerTitle, message: errorHandler.bannerMessage)
            .onChange(of: errorHandler.alertIsShown) { alertIsShown in
                if alertIsShown {
                    showAlert()
                }
            }
            .sheet(isPresented: $showDefinition) {
                DefinitionView(word: definitionToShow)
            }
            //        .overlay(DebugView(), alignment: .trailing)
        }
    }
    
    private func showAlert() {
        
        let alert =  UIAlertController(title: errorHandler.alertTitle,
                                       message: errorHandler.alertMessage,
                                       preferredStyle: .alert)
        
        let showDefinition = UIAlertAction(title: "Lookup '\(viewModel.wordle.capitalized)'", style: .default) { (action) in
            self.definitionToShow = viewModel.wordle
            self.showDefinition = true
            errorHandler.alertAction()
            errorHandler.alertIsShown = false
        }
        
        let showLeaderboards = UIAlertAction(title: "View Leaderboards", style: .default) { (action) in
            self.showLeaderboards = true
            errorHandler.alertAction()
            errorHandler.alertIsShown = false
        }
        
        let dismiss = UIAlertAction(title: "Continue", style: .cancel) { (action) in
            errorHandler.alertAction()
            errorHandler.alertIsShown = false
        }
        
        alert.addAction(showDefinition)
        alert.addAction(showLeaderboards)
        alert.addAction(dismiss)
        
        DispatchQueue.main.async {
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}



struct HintButton: View {
    var body: some View {
        Button(action: { }) {
            HStack {
                Image(systemName: "lightbulb.fill")
                Text("HINT")
                    .fontWeight(.medium)
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.KEYBOARD)
        .clipShape(Capsule())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.accentColor.ignoresSafeArea()
            ContentView()
                .environmentObject(WordleViewModel())
                .environmentObject(ErrorViewModel())
        }
    }
}
