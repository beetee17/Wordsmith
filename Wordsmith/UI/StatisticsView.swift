//
//  StatisticsView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 23/1/22.
//

import SwiftUI

struct StatisticsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.0001).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("STATISTICS")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.TEXT)
                
                HStack(alignment: .top) {
                    let numWins = Float(Player.guessDistribution.values.reduce(0, +))
                    
                    StatItemView(value: Player.numPlayed,
                                 stat: "Played")
                    
                    StatItemView(value: Int(numWins / Float(max(1, Player.numPlayed)) * 100),
                                 stat: "Win %")
                    
                    StatItemView(value: Player.currStreak,
                                 stat: "Current Streak")
                    
                    StatItemView(value: Player.bestStreak,
                                 stat: "Best Streak")
                }
                GuessDistribution()
                MostGuessed()
            }
            .frame(width: Device.width*0.85)
            .padding()
            .background(Color.STATSBG)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                Button(action: { withAnimation { isPresented = false } }) {
                    Image(systemName: "multiply.circle")
                        .resizable().scaledToFill()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.TEXT)
                        .padding(.trailing)
                        .padding(.top, 10)
                }, alignment: .topTrailing)
            
            .shadow(radius: 5)
        }
        
    }
}
struct GuessDistribution: View {
    @State private var dict = Player.guessDistribution
    
    var body: some View {
        
        let total = Float(dict.values.reduce(0, +))
        
        VStack(spacing: 5) {
            Text("GUESS DISTRIBUTION")
                .font(.system(size: 20, weight: .heavy, design: .default))
                .padding(.bottom)
                .foregroundColor(.TEXT)
            
            ForEach((1...6).map({"\($0)"}), id: \.self) { index in
                let value = Float(dict[index] ?? 0) / max(1, total)
                
                HStack {
                    Text(index)
                        .font(.title2)
                        .foregroundColor(.TEXT)
                        .frame(width:20)
                    Rectangle()
                        .foregroundColor(.PERFECT)
                        .frame(width: Device.width*0.7*CGFloat(value), height: 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 30)
        }
        
    }
}
struct MostGuessed: View {
    @State private var words: [String]
    
    init() {
        let dict = Player.guessHistory
        guard !dict.isEmpty else {
            self.words = []
            return
        }
        
        let sortedDict = dict.sorted {$0.1 > $1.1}
        self.words = sortedDict[0..<min(5, dict.count)].map({$0.0})
    }
    
    var body: some View {
        VStack {
            Text("MOST GUESSED")
                .font(.system(size: 20, weight: .heavy, design: .default))
                .padding(.bottom)
                .foregroundColor(.TEXT)
            
            ForEach(Array(zip(words.indices, words)), id: \.0) { index, word in
                HStack {
                    Text("\(index+1). ")
                        .frame(width:20)
                    Text(word)
                }
                .font(.title2)
                .textCase(.uppercase)
                .foregroundColor(.TEXT)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 30)
        }
    }
}
struct StatItemView: View {
    var value: Int
    var stat: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.largeTitle)
            
            Text(stat)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.TEXT)
        .frame(width: 80)
    }
}
struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            StatisticsView(isPresented: .constant(true))
        }
    }
}
