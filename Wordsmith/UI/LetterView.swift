//
//  LetterView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct LetterView: View {
    
    @State private var animating = false
    var letter: Letter?
    var isSelected: Bool
    var animationDuration = 0.2
    var size: CGFloat 
    let letterShape = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        let color = letter?.color
        
        ZStack {
            letterShape
                .stroke(getBorderColor(), lineWidth: isSelected ? 2.5 : 2)
                .background(letterShape.fill(color ?? Color.clear))
                .foregroundColor(color ?? .clear)
                .frame(width: size, height: size)
                .scaleEffect(animating ? 1.05 : 1)
                .animation(.easeInOut(duration: animationDuration))
            
            
            if let letter = letter {
                Text(letter.string)
                    .font(.system(size: size*0.6, weight: .heavy, design: .monospaced))
                    .foregroundColor(.TEXT)
                    .textCase(.uppercase)
                    .onAppear {
                        if !letter.isHint {
                            animating = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                animating = false
                            }
                        }
                    }
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1)
    }
    func getBorderColor() -> Color {
        if letter?.isHint ?? false {
            return .PERFECT
        }
        guard !isSelected else {
            return .HIGHLIGHT
        }
        guard let letter = letter else {
            return .LOWLIGHT.opacity(0.5)
        }
        guard let color = letter.color else {
            return .TEXT.opacity(0.8)
        }
        return color.opacity(0.2)
    }
}

struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.BG
            LetterView(letter: nil, isSelected: true, size: 60)
        }
    }
}
