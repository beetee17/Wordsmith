//
//  TopBar.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct TopBar: View {
    @EnvironmentObject var viewModel: WordSmithViewModel
    @Binding var showStats: Bool
    @Binding var showTutorial: Bool
    @Binding var showLeaderboards: Bool
    
    var body: some View {
        HStack {
            Button(action: { withAnimation { showTutorial = true } }) {
                Image(systemName: "questionmark.circle.fill")
                    .resizable().scaledToFill()
                    .frame(width:25, height: 25)
                    .foregroundColor(.TEXT)
            }
            
            Spacer()
            Button(action: { withAnimation { showLeaderboards = true } }) {
                Text("Win Streak: \(viewModel.currentStreak)")
                    .foregroundColor(.TEXT)
                    .font(.system(size: 20, weight: .bold, design: .default))
            }
            
            Spacer()

            Button(action: { withAnimation { showStats = true } }) {
                Image("chart.line.uptrend.xyaxis.circle.fill")
                    .resizable().scaledToFill()
                    .frame(width:25, height: 25)
                    .foregroundColor(.TEXT)
            }
        }
        .padding(.horizontal, 30)
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(showStats: .constant(false),
               showTutorial: .constant(false),
               showLeaderboards: .constant(false))
            .environmentObject(WordSmithViewModel())
    }
}
