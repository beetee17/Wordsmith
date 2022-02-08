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
    
    @State private var topSize: CGFloat = 0
    @State private var bottomSize: CGFloat = 0
    @State private var availableSize: CGFloat = 0
    
    @State private var showStats = false
    @State private var showTutorial = false
    
    var body: some View {
        if viewModel.showLeaderboards {
            
            GKLeaderboardView(isShowing: $viewModel.showLeaderboards)
                .transition(.move(edge: .bottom))
                
        } else {
            ZStack {
                Color.BG
                    .ignoresSafeArea()
                    .extractGeometry { frame in
                        availableSize = frame.height
                    }
                
                VStack {
                    
                    VStack {
                        TopBar(showStats: $showStats,
                               showTutorial: $showTutorial,
                               showLeaderboards: $viewModel.showLeaderboards)
                        GridView()
                    }.extractGeometry { frame in topSize = frame.height }
                    
                    
                    
                    HintButton(action: viewModel.getHint).frame(height: availableSize - (topSize + bottomSize + 10))
                    
                    
                    KeyboardView().extractGeometry { frame in bottomSize = frame.height }
                    
        
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
            .sheet(isPresented: $viewModel.showDefinition) {
                DefinitionView(word: viewModel.definitionToShow)
            }
            //        .overlay(DebugView(), alignment: .trailing)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.BG.ignoresSafeArea()
            ContentView()
                .environmentObject(WordleViewModel())
                .environmentObject(ErrorViewModel())
        }
    }
}
