//
//  AttemptView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct AttemptView: View {
    @EnvironmentObject var viewModel: WordSmithViewModel
    var attempt: [Letter?]
    var isSelectable: Bool
    
    var body: some View {
        let numLetters = attempt.count
        let letterSize = Device.height < 800 ? 58 / (Double(numLetters)/5) : min(90, Device.width/(Double(numLetters) + 1.4))
        
        ForEach(0...numLetters - 1, id: \.self) { i in
            let letter = attempt[i]
            if isSelectable {
                Button(action: { viewModel.updateSelection(to: i, action: .None) }) {
                    LetterView(letter: letter,
                               isSelected: viewModel.selection == i,
                               size: letterSize)
                    
                        .if(letter?.isHint ?? false) { $0.pulseEffect() }
                }
            } else {
                LetterView(letter: letter,
                           isSelected: false,
                           size: letterSize)
            }
        }
    }
}

struct AttemptView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.BG
            AttemptView(attempt: [], isSelectable: true).environmentObject(WordSmithViewModel())
        }
    }
}
