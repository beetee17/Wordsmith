//
//  DebugView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 4/2/22.
//

import SwiftUI

struct DebugView: View {
    
    @EnvironmentObject var viewModel: WordSmithViewModel
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading) {
                
                let attempts = viewModel.attempts
                
                Text("ATTEMPTS")
                    .font(.system(size: 20, weight: .heavy, design: .default))
                    .padding(.bottom)
                
                ForEach(0..<Global.maxAttempts, id: \.self) { i in
                    HStack {
                        Text("\(i+1). ")
                            .frame(width:20)
                        if i < attempts.count {
                            Text(attempts[i].toString())
                        }
                    }
                    .font(.title2)
                    .textCase(.uppercase)
                }
                Text(viewModel.answer)
                    .foregroundColor(.TEXT)
                    .font(.title2)
                    .textCase(.uppercase)
                    .padding(.top)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(viewModel.currentAttempt.toString())
                    .foregroundColor(.TEXT)
                    .font(.title2)
                    .textCase(.uppercase)
                    .padding(.top)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
        .foregroundColor(.TEXT)
        .padding(.horizontal)
        .background(Color.BG.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView().environmentObject(WordSmithViewModel())
    }
}
