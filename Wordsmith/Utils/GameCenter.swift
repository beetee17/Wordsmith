//
//  GameCenter.swift
//  Wordsmith
//
//  Created by Brandon Thio on 4/2/22.
//

import Foundation
import GameKit

struct GameCenter {
    static func authenticateUser() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { _, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }
    
    static func submitScore(of score: Int, to leaderboardID: LeaderBoardID) {
        if GKLocalPlayer.local.isAuthenticated {
            GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID.rawValue]) { error in
                print("Score Upload to \(leaderboardID) with error: \(String(describing: error))")
                if error != nil  {
                    ErrorViewModel.shared.showBanner(title: "Uploading Score to Game Center Failed", message: String(describing: error))
                }
            }
        } else {
            ErrorViewModel.shared.showBanner(title: "Could Not Upload Score to Game Center", message: "Login to Game Center to compete with others!")
        }
    }
}
