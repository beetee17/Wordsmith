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
                TopBar(showStats: $vm.showStats,
                       showTutorial: $vm.showTutorial,
                       showLeaderboards: $viewModel.showLeaderboards)
                GridView()
            }.extractGeometry { frame in vm.topSize = frame.height }
            
            
            
            HintButton(action: viewModel.getHint).frame(height: vm.hintButtonSize)
            
            
            KeyboardView()
                .background(Color.KEYBOARDBG.ignoresSafeArea().frame(height: vm.bottomSize + 20))
                .extractGeometry { frame in vm.bottomSize = frame.height }

        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(vm: ContentViewModel())
    }
}
