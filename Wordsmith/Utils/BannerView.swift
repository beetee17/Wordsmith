//
//  BannerView.swift
//  Wordsmith
//
//  Created by Brandon Thio on 22/1/22.
//

import SwiftUI

struct BannerView: View {
    let title: String
    let message: String
    
    var body: some View {
        Button(action: { }) {
            
            VStack(alignment: .leading, spacing:10) {
                HStack {
                    Image(systemName: "square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:25, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text("Wordle")
                        .foregroundColor(.white.opacity(0.7))
                }
                VStack(alignment: .leading, spacing:2) {
                    Text(title)
                        .bold()
                    Text(message)
                }
                .lineLimit(5)
                .foregroundColor(.white)
            }
            .padding(15)

            
        }
        .frame(width: Device.width-40, alignment: .leading)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.03205184274, green: 0.03314970656, blue: 0.04729758212, alpha: 1)).opacity(0.5), Color.accentColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
            
                LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.6), Color(#colorLiteral(red: 0.07820445112, green: 0.08963582299, blue: 0.09931479403, alpha: 1)).opacity(0.6)]), startPoint: .top, endPoint: .bottom)
            
            Color.black.opacity(0.4)
            }
            
        )
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
    }
}
struct BannerViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack(spacing: 0) {
                    
                    BannerView(title: title, message: message)
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.isPresented = false
                                }
                            }
                        }
                        .onTapGesture {
                            self.isPresented = false
                        }
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.5))
                .zIndex(1)
            }
        }
    }
}


extension View {
    func banner(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.modifier(BannerViewModifier(isPresented: isPresented, title: title, message: message))
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
            Text("Some Text")
            BannerView(title: "Oops, something went wrong", message: "Line 1.\nLine 1.\nLine 2.\nLine 3.\nLine 4.\nLine 5.")
        }
        
    }
}
