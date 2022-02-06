//
//  GKLeaderBoardView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 4/2/22.
//

import SwiftUI
import GameKit

struct GKLeaderboardView: UIViewControllerRepresentable {
    
    var leaderboardID: LeaderBoardID = .LongestStreak
    @Binding var isShowing: Bool
    
    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            print("DISMISSED")
            withAnimation {
                self.parent.isShowing = false
            }
            gameCenterViewController.parent?.dismiss(animated: false)
            
        }
        
        var parent: GKLeaderboardView
        
        init(_ parent: GKLeaderboardView) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let leaderboard = GKGameCenterViewController(leaderboardID: leaderboardID.rawValue, playerScope: .global, timeScope: .allTime)
        leaderboard.gameCenterDelegate = context.coordinator
        return leaderboard
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
}

struct GKLeaderboardUI: View {
    @State private var isShowing = false
    var body: some View {
        VStack {
            Button(action: { isShowing.toggle() }) {
                
                Text("Show leaderboard")
            }
            
            Button(action: { GameCenter.submitScore(of: 10, to: .LongestStreak) }) {
                
                Text("Submit Score of 10")
            }
            
            
        }
        .foregroundColor(.white)
        .sheet(isPresented: $isShowing) {
            GKLeaderboardView(leaderboardID: .LongestStreak, isShowing: $isShowing)
        }
    }
}


enum LeaderBoardID: String {
    case LongestStreak = "Longest_Streak"
}

struct GKLeaderboardUI_Previews: PreviewProvider {
    static var previews: some View {
        GKLeaderboardUI()
    }
}

