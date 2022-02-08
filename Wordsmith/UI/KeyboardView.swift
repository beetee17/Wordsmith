//
//  KeyboardView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct KeyboardView: View {
    
    @EnvironmentObject var viewModel: WordleViewModel
    @ObservedObject var keyboard = Keyboard.shared
    static var buttonHeight = Device.height*0.052
    
    var body: some View {
        let firstRow = keyboard.topRow
        let secondRow = keyboard.middleRow
        let thirdRow = keyboard.bottomRow
        
        let letter = GridItem(.flexible(), spacing: 5)
        let backspace = GridItem(.fixed(Device.width/7), spacing: 10)
        
        let enter = GridItem(.flexible(), spacing: 3)
        let spaceBar = GridItem(.fixed(Device.width*0.5), spacing: 5)
        let giveUp = GridItem(.flexible(), spacing: 5)
        
        
        
        VStack {
            LazyVGrid(columns: Array(repeating: letter,
                                     count: firstRow.count)) {
                ForEach(firstRow) { letter in
                    KeyboardLetter(letter: letter)
                }
            }
            
            LazyVGrid(columns: Array(repeating: letter,
                                     count:secondRow.count)) {
                ForEach(secondRow) { letter in
                    KeyboardLetter(letter: letter)
                }
            }
            .padding(.horizontal, Device.width/20)
            
            let thirdRowLayout = [
                [backspace],
                Array(repeating: letter,
                      count: thirdRow.count),
                [backspace]
            ].flatMap({$0})

            LazyVGrid(columns: thirdRowLayout) {
                Color.clear
                
                ForEach(thirdRow) { letter in
                    KeyboardLetter(letter: letter)
                }
                
                
                Button(action: viewModel.deleteChar) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: KeyboardView.buttonHeight)
                        .foregroundColor(Color.KEYBOARD)
                        .overlay(
                            Image(systemName: "delete.left.fill")
                                .resizable().scaledToFill()
                                .foregroundColor(.DELETE)
                                .scaleEffect(0.4)
                                
                        )
                        .padding(.leading, 5)
                    
                }
            }
            
            let bottomRowLayout = [
                [giveUp],
                [spaceBar],
                [enter]
            ].flatMap({$0})
            
            LazyVGrid(columns: bottomRowLayout) {
                
                Button(action: viewModel.surrender) {
                    // this button should pass the word
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: KeyboardView.buttonHeight)
                        .foregroundColor(Color.KEYBOARD)
                        .overlay(
                            Image(systemName: "flag.fill")
                                .resizable().scaledToFit()
                                .foregroundColor(.white)
                                .scaleEffect(0.4)
                                
                        )
                }
                Button(action: viewModel.incrementSelection ) {
                    // should increment selection
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: KeyboardView.buttonHeight)
                        .foregroundColor(Color.KEYBOARD)

                }
                
                Button(action: viewModel.confirmAttempt) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: KeyboardView.buttonHeight)
                        .foregroundColor(Color.KEYBOARD)
                        .overlay(
                            Image(systemName: "square.fill")
                                .resizable().scaledToFit()
                                .foregroundColor(.ENTER)
                                .scaleEffect(0.5)
                                
                        )
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

struct KeyboardLetter: View {
    
    @EnvironmentObject var viewModel: WordleViewModel
    var letter: Letter
    
    var body: some View {
        Button(action: { viewModel.addChar(Letter(letter.string)) }) {
            RoundedRectangle(cornerRadius: 5)
                .frame(height: KeyboardView.buttonHeight)
                .foregroundColor(letter.color)
                .animation(.easeInOut(duration: 0.2))
                .overlay(
                    Text(letter.string)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .textCase(.uppercase)
            )
        }
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
            .environmentObject(WordleViewModel())
    }
}
