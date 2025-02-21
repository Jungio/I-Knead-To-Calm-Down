import SwiftUI

struct BakeView: View {
    @State private var currentMessageIndex = 0
    @State private var showBakedBread = false
    @State private var navigateToEnd = false

    let messages = [
        "The dough is placed into the oven...",
        "You feel a bit better...",
        "The smell of freshly baked bread fills the air...",
        "You're proud of your efforts...",
        "It's done. You've successfully calmed down."
    ]

    var body: some View {
        ZStack {
            Image("KITCHEN")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                if currentMessageIndex < messages.count {
                    Text(messages[currentMessageIndex])
                        .font(.custom("SquadaOne-Regular", size: 55))
                        .foregroundColor(.black)
                        .padding()
                        .transition(.opacity)
                        .onAppear {
                            showNextMessage()
                        }
                } else if showBakedBread {
                    Image("bread")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 400)
                        .shadow(radius: 20)
                        .transition(.scale)
                        .padding(.bottom, 500)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation {
                                    navigateToEnd = true
                                    
                                }
                            }
                        }
                }
            }

            if navigateToEnd {
                EndView()
                    .transition(.opacity)
            }
        }
    }

    private func showNextMessage() {
        guard currentMessageIndex < messages.count else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(nil) {
                currentMessageIndex += 1
            }
            if currentMessageIndex < messages.count {
                showNextMessage()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        showBakedBread = true
                    }
                }
            }
        }
    }
}

struct EndView: View {
    
    var body: some View {
            ZStack {
   
                    Image("KITCHEN")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    Image("bread")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 400)
                        .shadow(radius: 20)
                        .transition(.scale)
                        .padding(.bottom, 500)
                    
                    VStack {
                        Text("The End")
                            .font(.custom("SquadaOne-Regular", size: 80))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                            .position(x: 685, y: 120)
                        
                        Text("Many people with anxiety could benefit from baking every once in a while.")
                            .font(.custom("SquadaOne-Regular", size: 45))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("And if you don't know how to cook, starting simple is the way to go.")
                            .font(.custom("SquadaOne-Regular", size: 45))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("Even something such as bread can help someone feel better.")
                            .font(.custom("SquadaOne-Regular", size: 45))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 425)
                        
                       
                }
            }
        }
    }
