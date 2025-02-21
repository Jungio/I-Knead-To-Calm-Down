import SwiftUI
import SpriteKit

struct KneadView: View {
    @State private var navigateToNextView = false
    @State private var isKneadingComplete = false

    var scene: KneadGameScene {
        let scene = KneadGameScene(size: CGSize(width: 400, height: 800))
        scene.scaleMode = .fill
        scene.onKneadingComplete = {
            withAnimation {
                isKneadingComplete = true
            }
        }
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)

            if isKneadingComplete {
                Button("next") {
                    withAnimation {
                        navigateToNextView = true
                    }
                }
                .padding()
                .font(.custom("SquadaOne-Regular", size: 50))
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .position(x: 1250, y: 900)
                .transition(.scale)
            }

            if navigateToNextView {
                BakeView()
                    .transition(.identity)
            }
        }
    }
}

class KneadGameScene: SKScene {
    private var dough: SKSpriteNode!
    private var messageLabel: SKLabelNode!
    private var background: SKSpriteNode!
    private var touchCount = 0
    private var currentDoughTextureIndex = 0
    private let doughTextures = ["dough1", "dough2", "dough3"] 
    private let messages = [
        "Keep up the good work",
        "You're doing great",
        "Put all of your frustrations into it",
        "Everything will be alright",
        "You're going to be fine"
    ]
    
    var onKneadingComplete: (() -> Void)?

    override func didMove(to view: SKView) {
        backgroundColor = .white
        background = SKSpriteNode(imageNamed: "marble")
        background.size = CGSize(width: 400, height: 800)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -10
        addChild(background)
       
        dough = SKSpriteNode(imageNamed: doughTextures[currentDoughTextureIndex])
        dough.position = CGPoint(x: size.width / 2, y: size.height / 2)
        dough.zPosition = 1
        dough.size = CGSize(width:200, height:500)
        addChild(dough)
        
        messageLabel = SKLabelNode(text: "Touch the screen to knead the dough")
        messageLabel.fontName = "SquadaOne-Regular"
        messageLabel.fontSize = 36
        messageLabel.fontColor = .black
        messageLabel.position = CGPoint(x: size.width / 2, y: size.height - 230)
        messageLabel.zPosition = 2
        messageLabel.numberOfLines = 3
        messageLabel.preferredMaxLayoutWidth = 250
        messageLabel.lineBreakMode = .byWordWrapping
        addChild(messageLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchCount < 50 else { return }

        touchCount += 1
        currentDoughTextureIndex = (currentDoughTextureIndex + 1) % doughTextures.count
        dough.texture = SKTexture(imageNamed: doughTextures[currentDoughTextureIndex])
        
        if touchCount % 5 == 0 {
            let messageIndex = min(touchCount / 5 - 1, messages.count - 1)
            messageLabel.text = messages[messageIndex]
        }
        
        if touchCount >= 50 {
            messageLabel.text = "It's ready, you did well"
            dough.texture = SKTexture(imageNamed: "dough1")
            isUserInteractionEnabled = false
            onKneadingComplete?()
        }
    }
}
