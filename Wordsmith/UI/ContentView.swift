//
//  ContentView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI
import CoreData

class ContentViewModel: ObservableObject {
    @Published var showStats = false {
        didSet { shouldUpdateFrame.toggle() }
    }
    @Published var showTutorial = false {
        didSet { shouldUpdateFrame.toggle() }
    }
    @Published var showGameModes = false {
        didSet { shouldUpdateFrame.toggle() }
    }
    
    @Published var availableSize: CGFloat = 0
    @Published var topSize: CGFloat = 0
    @Published var bottomSize: CGFloat = 0
    
    var shouldUpdateFrame: Bool = false
    
    var hintButtonSize: CGFloat {
        availableSize - (topSize + bottomSize + 30)
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: WordSmithViewModel
    @EnvironmentObject var errorHandler: ErrorViewModel
    @StateObject var vm = ContentViewModel()
    
    var body: some View {
        if viewModel.showLeaderboards {
            
            GKLeaderboardView(isShowing: $viewModel.showLeaderboards)
                .transition(.move(edge: .bottom))
                
        } else {
            ZStack {
                Color.BG
                    .ignoresSafeArea()
                    .modifier(GeometryExtractor(value: .constant(true)) { frame in
                        print("Available Frame change to \(frame.height)")
                        vm.availableSize = frame.height })
                
                GameView(vm: vm).opacity(vm.showStats ? 0.2 : 1)
                
                if vm.showStats {
                    StatisticsView(isPresented: $vm.showStats)
                        .zIndex(1) // removal transition does not animate when zIndex is not set
                        .transition(.scale)
                }
                if vm.showTutorial {
                    TutorialView(isPresented: $vm.showTutorial)
                        .zIndex(1) // removal transition does not animate when zIndex is not set
                        .transition(.scale)
                }
                if vm.showGameModes {
                    GameModes(isPresented: $vm.showGameModes)
                        .zIndex(1) // removal transition does not animate when zIndex is not set
                        .transition(.scale)
                }
            }
            .banner(isPresented: $errorHandler.bannerIsShown, title: errorHandler.bannerTitle, message: errorHandler.bannerMessage)
            .sheet(isPresented: $viewModel.showDefinition) {
                DefinitionView(word: viewModel.definitionToShow)
            }
//            .overlay(DebugView(), alignment: .trailing)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 8 Plus")
            
            ContentView()
                .previewDevice("iPhone 12")
            
            ContentView()
                .previewDevice("iPhone 12 Pro Max")
            
            ContentView()
                .previewDevice("iPad Air (4th generation)")
        }
        .environmentObject(WordSmithViewModel())
        .environmentObject(ErrorViewModel())
        .environment(\.managedObjectContext, moc_preview)
    }
}
