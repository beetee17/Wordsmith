//
//  GridView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var viewModel: WordSmithViewModel
    
    var body: some View {
        let attempts = viewModel.attempts
        let currentAttempt = viewModel.currentAttempt
        let numLetters = viewModel.game.numLetters
        let columns: [GridItem] = Array(repeating: .init(.flexible()),
                                        count: numLetters)
        VStack {
            ForEach(0...Global.maxAttempts-1, id: \.self) { i in
                LazyVGrid(columns: columns) {
                    if i < attempts.count  {
                        AttemptView(attempt: attempts[i],
                                    isSelectable: false)
                    } else if i == attempts.count {
                        AttemptView(attempt: currentAttempt,
                                    isSelectable: true)
                    } else {
                        AttemptView(attempt: Array(repeating: nil,
                                                   count: numLetters),
                                    isSelectable: false)
                    }
                    
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(maxWidth: 600 + CGFloat((numLetters - 5)*100))
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
            .environmentObject(WordSmithViewModel())
    }
}
