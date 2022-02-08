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
    
    var body: some View {
        let topRow = keyboard.topRow
        let middleRow = keyboard.middleRow
        let bottomRow = keyboard.bottomRow
        let letterGridItem = GridItem(.flexible(), spacing: 3)
        let buttonGridItem = GridItem(.fixed(Device.width/7), spacing: 3)
        
        VStack {
            LazyVGrid(columns: Array(repeating: letterGridItem,
                                     count: topRow.count)) {
                ForEach(topRow) { letter in
                    KeyboardLetter(letter: letter)
                }
            }
            
            LazyVGrid(columns: Array(repeating: letterGridItem,
                                     count:middleRow.count)) {
                ForEach(middleRow) { letter in
                    KeyboardLetter(letter: letter)
                }
            }
            .padding(.horizontal, Device.width/20)
            
            let bottomLayout = [
                [buttonGridItem],
                Array(repeating: letterGridItem,
                      count: bottomRow.count),
                [buttonGridItem]
            ].flatMap({$0})

            LazyVGrid(columns: bottomLayout) {
                
                Button(action: viewModel.confirmAttempt) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: Device.width/7, height:Device.height*0.07)
                        .foregroundColor(Color.KEYBOARD)
                        .overlay(
                            Image(systemName: "square.fill")
                                .resizable().scaledToFill()
                                .foregroundColor(.ENTER)
                                .scaleEffect(0.3)
                                
                        )
                }
                
                ForEach(bottomRow) { letter in
                    KeyboardLetter(letter: letter)
                }
                
                
                Button(action: viewModel.deleteChar) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: Device.width/7, height: Device.height*0.07)
                        .foregroundColor(Color.KEYBOARD)
                        .overlay(
                            Image(systemName: "delete.left.fill")
                                .resizable().scaledToFill()
                                .foregroundColor(.DELETE)
                                .scaleEffect(0.3)
                                
                        )
                    
                }
            }
        }
        .padding(5)
    }
}

struct KeyboardLetter: View {
    
    @EnvironmentObject var viewModel: WordleViewModel
    var letter: Letter
    
    var body: some View {
        Button(action: { viewModel.addChar(Letter(letter.string)) }) {
            RoundedRectangle(cornerRadius: 5)
                .frame(height: Device.height*0.07)
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
