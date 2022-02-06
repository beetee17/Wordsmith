//
//  Extensions.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI


extension Color {
    static let PERFECT = Color(.init(named: "Perfect")!)
    static let ALMOST = Color(.init(named: "Almost")!)
    static let WRONG = Color(.init(named: "Wrong")!)
    static let KEYBOARD = Color(.init(named: "Keyboard")!)
    static let ENTER = Color(.init(named: "Enter")!)
    static let DELETE = Color(.init(named: "Delete")!)
    
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
}
