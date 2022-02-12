//
//  GameView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 12/2/22.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: WordSmithViewModel
    @EnvironmentObject var errorHandler: ErrorViewModel
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
        VStack {
            
            VStack {
                TopBar(contentVM: vm)
                GridView()
            }
            .modifier(GeometryExtractor(value: $vm.shouldUpdateFrame) { frame in
                print("Top Frame change to \(frame.height)")
                vm.topSize = frame.height })
            
            
            
            HintButton(action: viewModel.getHint).frame(height: vm.hintButtonSize)
            
            
            KeyboardView()
                .background(Color.KEYBOARDBG.ignoresSafeArea().frame(height: vm.bottomSize + 20))
                .modifier(GeometryExtractor(value: $vm.shouldUpdateFrame) { frame in
                    print("Bottom Frame change to \(frame.height)")
                    vm.bottomSize = frame.height })

        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(vm: ContentViewModel())
    }
}
