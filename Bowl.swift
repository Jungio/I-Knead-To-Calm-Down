import SwiftUI
import SpriteKit

struct BowlView: View {
    @State private var allIngredientsAdded = false
    @State private var navigateToNextView = false

    var bowlScene: BowlGameScene {
        let scene = BowlGameScene(size: CGSize(width: 400, height: 800))
        scene.scaleMode = .fill
        scene.onAllIngredientsAdded = {
            allIngredientsAdded = true
        }
        return scene
    }

    var body: some View {
        ZStack {
            if navigateToNextView {
                MixView()
                    .transition(.identity)
            } else {
                ZStack {
                    SpriteView(scene: bowlScene)
                        .edgesIgnoringSafeArea(.all)

                    if allIngredientsAdded {
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
                    }
                }
            }
        }
    }
}

class BowlGameScene: SKScene {
    private var bowl: SKSpriteNode!
    private var background: SKSpriteNode!
    private var mainLabel: SKLabelNode!
    private var instructionLabel: SKLabelNode!
    private var ingredients: [SKSpriteNode] = []
    private var addedIngredients: [SKSpriteNode] = []
    private var firstTouchDone = false
    private var firstIngredientDropped = false

    private let ingredientTextures: [String: String] = [
        "Flour": "flour2",
        "Water": "water2",
        "Salt": "salt2",
        "Sugar": "sugar2",
        "Yeast": "yeast2"
    ]
    
    var onAllIngredientsAdded: (() -> Void)?

    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        background = SKSpriteNode(imageNamed: "marble")
        background.size = CGSize(width: 400, height: 800)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -10
        addChild(background)
        
        bowl = SKSpriteNode(imageNamed: "bowl_empty")
        bowl.size = CGSize(width: 200, height: 400)
        bowl.position = CGPoint(x: frame.midX, y: 250)
        bowl.zPosition = 1
        addChild(bowl)
        
        mainLabel = SKLabelNode(text: "Maybe this will help...")
        mainLabel.fontName = "SquadaOne-Regular"
        mainLabel.fontSize = 36
        mainLabel.fontColor = .black
        mainLabel.position = CGPoint(x: frame.midX, y: frame.midY + 275)
        mainLabel.zPosition = 5
        mainLabel.horizontalAlignmentMode = .center
        mainLabel.verticalAlignmentMode = .center
        mainLabel.setScale(1.0)
        mainLabel.alpha = 0
        addChild(mainLabel)

        let ingredientNames = ["Flour", "Water", "Salt", "Sugar", "Yeast"]
        for (index, name) in ingredientNames.enumerated() {
            let ingredient = SKSpriteNode(imageNamed: name.lowercased())
            ingredient.size = CGSize(width: 100, height: 250)
            ingredient.name = name
            ingredient.position = CGPoint(x: 80 + CGFloat(index) * 70, y: 550)
            ingredient.isUserInteractionEnabled = false
            ingredients.append(ingredient)
            addChild(ingredient)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let touchedNode = nodes(at: location).first as? SKSpriteNode, ingredients.contains(touchedNode) {
            touchedNode.zPosition = 10

            if !firstTouchDone {
                firstTouchDone = true
                
                
                mainLabel.run(SKAction.fadeIn(withDuration: 0.5))
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let draggedNode = nodes(at: location).first as? SKSpriteNode, ingredients.contains(draggedNode) {
            draggedNode.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let droppedNode = nodes(at: location).first as? SKSpriteNode, ingredients.contains(droppedNode) {
            if bowl.frame.contains(location) {
                let ingredientName = droppedNode.name ?? ""
                
                droppedNode.removeFromParent()
                ingredients.removeAll { $0 == droppedNode }

                if let textureName = ingredientTextures[ingredientName] {
                    let ingredientPile = SKSpriteNode(imageNamed: textureName)
                    ingredientPile.size = CGSize(width: 200, height: 400)
                    ingredientPile.position = CGPoint(x: bowl.position.x, y: bowl.position.y + CGFloat(addedIngredients.count))
                    ingredientPile.zPosition = CGFloat(addedIngredients.count + 1)
                    addChild(ingredientPile)
                    addedIngredients.append(ingredientPile)
                }

                if !firstIngredientDropped {
                    firstIngredientDropped = true

                    
                    let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                    mainLabel.run(fadeOutAction) {
                        self.mainLabel.removeFromParent()
                    }
                    
                }

                if addedIngredients.count == ingredientTextures.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.onAllIngredientsAdded?()
                    }
                }
            }
        }
    }
}
