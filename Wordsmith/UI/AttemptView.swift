//
//  AttemptView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct AttemptView: View {
    @EnvironmentObject var viewModel: WordleViewModel
    var attempt: [Letter?]
    var isSelectable: Bool
    
    var body: some View {
        
        ForEach(0...Game.numLetters-1, id: \.self) { i in
            if isSelectable {
                Button(action: { viewModel.updateSelection(to: i, action: .None) }) {
                    LetterView(letter: attempt[i], isSelected: viewModel.selection == i)
                }
            } else {
                LetterView(letter: attempt[i], isSelected: false)
            }
        }
    }
}

struct AttemptView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.accentColor
            AttemptView(attempt: [], isSelectable: true).environmentObject(WordleViewModel())
        }
    }
}
