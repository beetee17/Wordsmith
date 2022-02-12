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
                                    count: Global.numLetters)
    let answer = "words"
    let fontSize = Device.width*0.025
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color.BG.ignoresSafeArea()
            
            VStack(spacing: min(20, Device.height/75)) {
                HStack {
                    Spacer()
                    Text("HOW TO PLAY")
                        .font(.largeTitle).bold()
                        .foregroundColor(.TEXT)
                    
                    Spacer()
                        .overlay(Button(action: { withAnimation { isPresented = false } }) {
                            Image(systemName: "multiply.circle")
                                .resizable().scaledToFill()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.TEXT)
                                .padding(.trailing)
    
                        }, alignment: .trailing)
                }
                
                Text("Guess the word in 6 tries! \n\nEach guess must be a valid word.")
                    .font(.headline).bold()
                    .padding(5)
                    .foregroundColor(.TEXT)
                  
                
                Text("EXAMPLE")
                    .font(.title).bold()
                    .padding()
                    .foregroundColor(.TEXT)
                
                VStack(spacing: min(20, Device.height/75)) {
                    LazyVGrid(columns: columns) {
                        AttemptView(attempt: [Letter].init("while", answer: "wixxh"),
                                    isSelectable: false)
                    }.padding(.horizontal, 10)
                    
                    Text("W is in the word and in the correct spot.\n\nH and I are in the word but in the wrong spots.\n\nL and E are not in the word.")
                        .font(.headline).bold()
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.TEXT)
                    
                    Text("SPECIAL CASES")
                        .font(.title).bold()
                        .padding()
                        .foregroundColor(.TEXT)
                    
                    LazyVGrid(columns: columns) {
                        AttemptView(attempt: [Letter].init("apart", answer: "axxax"),
                                    isSelectable: false)
                    }.padding(.horizontal, 10)
                    
                    
                    Text("There are two A's in the word.")
                        .font(.headline).bold()
                        .foregroundColor(.TEXT)
                    
                    LazyVGrid(columns: columns) {
                        AttemptView(attempt: [Letter].init("green", answer: "xxxex"),
                                    isSelectable: false)
                    }.padding(.horizontal, 10)
                    
                    Text("There is only one E in the word.")
                        .font(.headline).bold()
                        .foregroundColor(.TEXT)
                }
                .frame(maxWidth: 550)
            }
            .padding(.top, 10)
        }
    }
    
    func makeAttempt(from word: String) -> [Letter] {
        var attempt: [Letter] = []
        for char in word {
            attempt.append(Letter(String(char)))
        }
        attempt.setColor(for: answer)
        return attempt
    }
}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        
        TutorialView(isPresented: .constant(true))
        
    }
}
