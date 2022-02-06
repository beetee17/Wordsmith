//
//  DefinitionView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 17/1/22.
//

import SwiftUI

struct DefinitionUIView: UIViewControllerRepresentable {
    
    var word: String
    
    func makeUIViewController(context: Context) -> UIReferenceLibraryViewController {
        let vc = UIReferenceLibraryViewController(term: word)
        return vc
    }

    func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: Context) {
        uiViewController.view.tintColor = .white
    }
}

// From https://stackoverflow.com/questions/64764292/how-to-change-uireferencelibraryviewcontroller-view-dismiss-done-button-to-an
extension UIView {
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}

struct DefinitionView: View {
    var word: String
    
    var body: some View {
        DefinitionUIView(word: word)
    }
}
struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(word: "hello")
    }
}
