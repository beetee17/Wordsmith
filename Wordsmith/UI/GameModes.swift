//
//  GameModes.swift
//  Wordsmith
//
//  Created by Brandon Thio on 12/2/22.
//

import SwiftUI
import CoreData

struct GameModes: View {
    @EnvironmentObject var viewModel: WordSmithViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Game.numLetters_, ascending: true)],
        animation: .default)
    private var modes: FetchedResults<Game>
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.BG.ignoresSafeArea()
            VStack(spacing: 50) {
                ForEach(modes) { mode in
                    Button(action: {
                        withAnimation {
                            viewModel.setGame(mode)
                            isPresented = false
                        }
                    }) {
                        Text("\(mode.numLetters) letter words")
                            .foregroundColor(.TEXT)
                            .textCase(.uppercase)
                            .font(.system(size: 25, weight: .heavy, design: .rounded))
                    }
                }
            }
        }
        .overlay(
            HStack {
                Spacer()
                Text("SELECT DIFFICULTY")
                    .font(.title).bold()
                    .foregroundColor(.TEXT)
                
                Spacer()
                    .overlay(Button(action: { withAnimation { isPresented = false } }) {
                        Image(systemName: "multiply.circle")
                            .resizable().scaledToFill()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.TEXT)
                            .padding(.trailing)

                    }, alignment: .trailing)
            }.padding(.top), alignment: .top
        )
        .buttonStyle(ScaleEffect())
    }
}

struct GameModes_Previews: PreviewProvider {
    static var previews: some View {
        GameModes(isPresented: .constant(false))
            .environment(\.managedObjectContext, moc_preview)
    }
}
