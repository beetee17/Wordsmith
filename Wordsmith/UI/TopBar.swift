//
//  TopBar.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct TopBar: View {
    @EnvironmentObject var viewModel: WordSmithViewModel
    @ObservedObject var contentVM: ContentViewModel
    
    var body: some View {
        
        HStack {
            
            Spacer()
                .frame(width:Device.width*0.1)
                .overlay(
                    Button(action: { withAnimation { contentVM.showTutorial = true } }) {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable().scaledToFill()
                            .frame(width:25, height: 25)
                            .foregroundColor(.TEXT)
                    }
                )
            
            Spacer()
                .frame(width: Device.width*0.65)
                .overlay(
                    Button(action: { withAnimation { viewModel.showLeaderboards = true } }) {
                        Text("Win Streak: \(viewModel.game.currStreak)")
                            .foregroundColor(.TEXT)
                            .font(.system(size: 20, weight: .bold, design: .default))
                    }
                )
            
            Spacer()
                .frame(width:Device.width*0.1)
                .overlay(
                    HStack(spacing:10) {
                        Button(action: { withAnimation { contentVM.showStats = true } }) {
                            Image("chart.line.uptrend.xyaxis.circle.fill")
                                .resizable().scaledToFill()
                                .frame(width:25, height: 25)
                                .foregroundColor(.TEXT)
                        }
                        Button(action: { withAnimation { contentVM.showGameModes = true } }) {
                            Image("line.3.horizontal")
                                .resizable().scaledToFit()
                                .frame(width:30, height: 30)
                                .foregroundColor(.TEXT)
                        }
                    }
                )
        }
        .frame(height:30)
        .buttonStyle(ScaleEffect())
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(contentVM: ContentViewModel())
            .environmentObject(WordSmithViewModel())
    }
}
