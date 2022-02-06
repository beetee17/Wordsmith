//
//  TutorialView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 3/2/22.
//

import SwiftUI

struct TutorialView: View {
    @Binding var isPresented: Bool
    let columns: [GridItem] = Array(repeating: .init(.flexible()),
                                    count: Game.numLetters)
    let wordle = "words"
    let fontSize = Device.width*0.025
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color.accentColor.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Text("HOW TO PLAY")
                        .font(.largeTitle).bold()
                    Spacer()
                        .overlay(Button(action: { withAnimation { isPresented = false } }) {
                            Image(systemName: "multiply.circle")
                                .resizable().scaledToFill()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(.trailing)
    
                        }, alignment: .trailing)
                }
                
                Text("Guess the word in 6 tries! \n\nEach guess must be a valid word. \n\nAfter each guess, the cells will change color to show how close your guess was to the word.")
                    .font(.headline).bold()
                    .padding()
                
                Text("EXAMPLE")
                    .font(.title).bold()
                VStack(spacing: 20) {
                    LazyVGrid(columns: columns) {
                        AttemptView(attempt: makeAttempt(from: "while"),
                                    isSelectable: false)
                    }.padding(.horizontal, 10)
                    
                    Text("W is in the word and in the correct spot.")
                        .font(.headline).bold()
                    
                    LazyVGrid(columns: columns) {
                        AttemptView(attempt: makeAttempt(from: "cadet"),
                                    isSelectable: false)
                    }.padding(.horizontal, 10)
                    
                    Text("D is in the word but in the wrong spot.")
                        .font(.headline).bold()
                    
                    LazyVGrid(columns: columns) {
                        AttemptView(attempt: makeAttempt(from: "quite"),
                                    isSelectable: false)
                    }.padding(.horizontal, 10)
                    
                    Text("None of the letters are in the correct spot.")
                        .font(.headline).bold()
                }
                
            }
            
        }
    }
    
    func makeAttempt(from word: String) -> [Letter] {
        var attempt: [Letter] = []
        for char in word {
            attempt.append(Letter(String(char)))
        }
        attempt.setColor(for: wordle)
        return attempt
    }
}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        
        TutorialView(isPresented: .constant(true))
        
    }
}
