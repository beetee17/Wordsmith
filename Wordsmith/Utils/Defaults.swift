//
//  Defaults.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI

struct Device {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

struct Global {
    static let dictionary = loadWords("words")
    static let maxAttempts = 6
}

// Loading of Data
func loadWords(_ filename: String) -> [String] {
    
    do {
        print("loading \(String(describing: filename))")
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
            print("no path found")
            return []
        }
        
        let words = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: "\n")
        
        return words
        
    } catch {
        print(error.localizedDescription)
    }
    return []
}
