import SwiftUI

struct IntroView: View {
    
    @State private var showCharacter = false
    @State private var showText1 = false
    @State private var showText2 = false
    @State private var showAnimatedBackground = false
    @State private var showInstructions = false
    @State private var tapCount = 0
    @State private var navigateToGame = false
    @State private var currentText1 = ""
    @State private var currentText2 = ""
    @State private var showButton = false
    
    let monologues = [
        "Where am I?",
        "It's dark in here..",
        "Feels like I'm drowning...",
        "Can you help me?"
    ]
    
    let postTransitionMonologues = [
        "Thanks",
        "But I still feel a bit lost...",
        "...",
        "I need to calm down"
    ]
    
    var body: some View {
        ZStack {
            if navigateToGame {
                
                BowlView()
                    .transition(.identity)
            } else {
              
                ZStack {
                    if showAnimatedBackground {
                        AnimatedBackground()
                        
                        if showCharacter {
                            Image("char")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 400)
                                .transition(.opacity)
                                .padding(.top, 100)
                        }
                    } else {
                        Color.black.edgesIgnoringSafeArea(.all)
                    }
                    ZStack {
                        VStack {
                            Text(currentText1)
                                .font(.custom("SquadaOne-Regular", size:75))
                                .foregroundColor(.white)
                                .opacity(showText1 ? 1 : 0)
                                .transition(.opacity)
                                .padding()
                            
                            if showInstructions {
                                Text("Tap the screen repeatedly to help clear the mind.")
                                    .font(.system(size: 30))
                                    .foregroundColor(.yellow)
                                    .opacity(showInstructions ? 1 : 0)
                                    .transition(.opacity)
                                    .padding(.top, 10)
                            }
                        }
                        Text(currentText2)
                            .font(.custom("SquadaOne-Regular", size:75))
                            .foregroundColor(.white)
                            .opacity(showText2 ? 1 : 0)
                            .transition(.opacity)
                            .padding(.bottom, 500)
                    }
                    
                    if showButton {
                        Button("next") {
                            navigateToGame = true
                        }
                        .padding()
                        .font(.custom("SquadaOne-Regular", size:50))
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .position(x: 1250, y: 900)
                    }
                }
            }
        }
        .onAppear {
            startIntroSequence()
        }
        .onTapGesture {
            handleTap()
        }
    }
    
    private func startIntroSequence() {
        for (i, text) in monologues.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5 * Double(i + 1)) {
                withAnimation(nil) {
                    currentText1 = text
                    showText1 = true
                }
                if i == monologues.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showInstructions = true
                        }
                    }
                }
            }
        }
    }
    
    private func handleTap() {
        tapCount += 1
        
        if showInstructions && tapCount == 5 {
            withAnimation {
                showAnimatedBackground = true
                showInstructions = false
                showText1 = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    showCharacter = true
                }
                for (i, text) in postTransitionMonologues.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5 * Double(i + 1)) {
                        withAnimation(nil) {
                            currentText2 = text
                            showText2 = true
                        }
                        
                        if text == "I need to calm down" {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    showButton = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AnimatedBackground: View { 
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
    }
}
