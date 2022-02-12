//
//  Extensions.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI


extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

extension Color {
    static let BG = Color(.init(named: "BG")!)
    static let PERFECT = Color(.init(named: "Perfect")!)
    static let ALMOST = Color(.init(named: "Almost")!)
    static let WRONG = Color(.init(named: "Wrong")!)
    static let KEYBOARD = Color(.init(named: "Keyboard")!)
    static let KEYBOARDBG = Color(.init(named: "KeyboardBG")!)
    static let STATSBG = Color(.init(named: "StatsBG")!)
    static let ENTER = Color(.init(named: "Enter")!)
    static let DELETE = Color(.init(named: "Delete")!)
    static let TEXT = Color(.init(named: "Text")!)
    static let HIGHLIGHT = Color(.init(named: "Highlight")!)
    static let LOWLIGHT = Color(.init(named: "Lowlight")!)
    static let HINT = Color(.init(named: "Hint")!)
    
    static let darkStart = Color.BG.opacity(0.5)
    static let darkEnd = Color(red: 15 / 255, green: 15 / 255, blue: 10 / 255)

    
    /// This function should only be called if `lhs` and `rhs` are one of the four colors above
    static func max(_ lhs: Color, _ rhs: Color) -> Color {
        switch lhs {
        case .KEYBOARD:
            return rhs
        case .WRONG:
            return rhs == .KEYBOARD ? lhs : rhs
            
        case .ALMOST:
            return rhs == .WRONG || rhs == .KEYBOARD ? lhs : rhs
            
        case .PERFECT:
            return lhs
            
        default:
            return lhs
        }
    }
}



extension Array where Element == Letter {
    func toString() -> String {
        return self.reduce(into: "") { res, char in
            res += char.string
        }
    }
    init(_ str: String, answer: String? = nil) {
        self.init()
        for index in str.indices {
            let letter = Letter(String(str[index]))
            self.append(letter)
        }
        if let answer = answer {
            self.setColor(for: answer, numLetters: answer.count)
        }
    }
}

extension Array where Element == Letter? {
    func toString() -> String {
        return self.reduce(into: "") { res, char in
            if let char = char {
                res += char.string
            } else {
                res += " "
            }
        }
    }
}

extension Array where Element: Comparable {
    
    /// Binary search function
    func search(element: Element) -> Int {
        
        var low = 0
        var high = count - 1
        var mid = Int(high / 2)
        
        while low <= high {
            
            let midElement = self[mid]
            
            if element == midElement {
                return mid
            }
            else if element < midElement {
                high = mid - 1
            }
            else {
                low = mid + 1
            }
            
            mid = (low + high) / 2
        }
        
        return -1
    }
    
}

struct PulseEffect: ViewModifier {
    @State var isOn = false
    var animation = Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(self.isOn ? 1 : 0.9)
            .opacity(self.isOn ? 1 : 0.8)
            .animation(animation, value: isOn)
            .onAppear {
                self.isOn = true
            }
    }
}

struct GeometryExtractor: ViewModifier {
    @Binding var value: Bool
    var completion: (CGRect) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader{ geo in
                Color.clear
                    .onAppear { completion(geo.frame(in: .global)) }
                    .onChange(of: value, perform: { val in completion(geo.frame(in: .global)) })
            })
    }
}

struct ScaleEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
    }
}

// Conditional Modifier
// Text("some Text").if(modifierEnabled) { $0.foregroundColor(.Red) }
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
    func pulseEffect() -> some View  {
        self.modifier(PulseEffect())
    }
}
