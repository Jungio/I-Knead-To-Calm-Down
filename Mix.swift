import SwiftUI
import SpriteKit

struct MixView: View {
    @State private var navigateToNextView = false
    @State private var isMixingComplete = false
    @State private var showInstructions = true
    
    var scene: MixGameScene {
        let scene = MixGameScene(size: CGSize(width: 400, height: 800))
        scene.scaleMode = .fill
        scene.onMixingStart = {
            withAnimation(.easeOut(duration: 1)) {
                showInstructions = false
            }
        }
        scene.onMixingComplete = {
            withAnimation {
                isMixingComplete = true
            }
        }
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
            
            if showInstructions {
                Text("Spin to mix the ingredients")
                    .font(.custom("SquadaOne-Regular", size: 75))
                    .foregroundColor(.black)
                    .padding()
                    .cornerRadius(10)
                    .position(x: 700, y: 150)
                    .transition(.opacity)
            }
            
            if isMixingComplete {
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
                KneadView()
                    .transition(.identity)
            }
        }
    }
}

class MixGameScene: SKScene {
    private var bowl: SKSpriteNode!
    private var ingredients: [SKSpriteNode] = []
    private var mixedDough: SKSpriteNode!
    private let ingredientNames = ["Flour2", "Water2", "Salt2", "Sugar2", "Yeast2"]
    private var touchActive = false
    private var angle: CGFloat = 0.0
    var isMixingComplete = false
    var onMixingStart: (() -> Void)?
    var onMixingComplete: (() -> Void)?

    private var mixingProgressLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
        let background = SKSpriteNode(imageNamed: "marble")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -10
        addChild(background)
        
        bowl = SKSpriteNode(imageNamed: "bowl_empty")
        bowl.position = CGPoint(x: size.width / 2, y: size.height / 3)
        bowl.size = CGSize(width: 200, height: 400)
        addChild(bowl)
        
        let radius: CGFloat = 40
        for (index, name) in ingredientNames.enumerated() {
            let ingredient = SKSpriteNode(imageNamed: name.lowercased())
            ingredient.size = CGSize(width: 150, height: 150)
            let angleOffset = (CGFloat(index) / CGFloat(ingredientNames.count)) * .pi * 2
            ingredient.position = CGPoint(
                x: bowl.position.x + cos(angleOffset) * radius,
                y: bowl.position.y + sin(angleOffset) * radius
            )
            ingredients.append(ingredient)
            addChild(ingredient)
        }
        
        mixedDough = SKSpriteNode(imageNamed: "dough1")
        mixedDough.position = bowl.position
        mixedDough.size = bowl.size
        mixedDough.isHidden = true
        addChild(mixedDough)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isMixingComplete else { return }
        touchActive = true
        onMixingStart?()

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchActive, !isMixingComplete, let touch = touches.first else { return }
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        let dx = location.x - previousLocation.x
        let dy = location.y - previousLocation.y
        let rotationSpeed: CGFloat = 0.05
        angle += (dx + dy) * rotationSpeed

        let radius: CGFloat = 40
        for (index, ingredient) in ingredients.enumerated() {
            let angleOffset = angle + (CGFloat(index) / CGFloat(ingredients.count)) * .pi * 2
            ingredient.position = CGPoint(
                x: bowl.position.x + cos(angleOffset) * radius,
                y: bowl.position.y + sin(angleOffset) * radius
            )
        }
        
        let progress = min(3.0, abs(angle) / 10)


        if progress >= 3.0 {
            completeMixing()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchActive = false
    }
    

    
    private func completeMixing() {
        isMixingComplete = true
        ingredients.forEach { $0.removeFromParent() }
        bowl.isHidden = true
        mixedDough.isHidden = false

        onMixingComplete?()
    }
}
