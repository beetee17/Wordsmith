//
//  ErrorViewModel.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import Foundation
import SwiftUI

/// View model that controls the display of pop-up and banner notifications
class ErrorViewModel: NSObject, ObservableObject {
    
    static let shared = ErrorViewModel()
    
    /// True if a pop-up notification should be shown to the user
    @Published var alertIsShown = false {
        didSet {
            print("SET alertIsShown to \(alertIsShown)")
        }
    }
    
    /// Title of the pop-up
    @Published var alertTitle = ""
    
    @Published var alertMessage = ""
    
    var alertAction: () -> Void = {}
    
    /// True if a banner notification should be shown to the user
    @Published var bannerIsShown = false
    /// Title of the banner
    @Published var bannerTitle = ""
    /// Contents of the banner
    @Published var bannerMessage = ""
    
    /// Displays a pop-up notification
    /// - Parameters:
    ///   - title: The title of the notification
    ///   - message: The message of the notification
    func showAlert(_ title: String, _ message: String, _ action: @escaping () -> Void) {
        guard !alertIsShown else { return }
        
        alertTitle = title
        alertMessage = message
        alertAction = action
        alertIsShown = true
        
    }
    
    /// Displays a banner-style notification
    /// - Parameters:
    ///   - title: The title of the notification
    ///   - message: The message of the notification
    func showBanner(title: String, message: String) {
        guard !bannerIsShown else { return }
        
        bannerTitle = title
        bannerMessage = message
        bannerIsShown = true
    }
    
}
