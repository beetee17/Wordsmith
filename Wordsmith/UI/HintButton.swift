//
//  HintButton.swift
//  Wordsmith
//
//  Created by Brandon Thio on 7/2/22.
//

import SwiftUI



struct HintButton: View {
    
    var action: () -> Void
    
    var body: some View {
    
        Button(action: action) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.TEXT.opacity(0.9))
                    
                Text("HINT")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.TEXT)
            }
        }
        .buttonStyle(DarkButtonStyle())
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 0)
    }
}

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .foregroundColor(.yellow)
            .background(
                Color.HINT
//                DarkBackground(isHighlighted: configuration.isPressed, shape: Capsule())
            )
            .clipShape(Capsule())
        
            .animation(nil)
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                  .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}


struct HintButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(Color.darkStart, Color.darkEnd)
            HintButton(action: {})
        }
    }
}
