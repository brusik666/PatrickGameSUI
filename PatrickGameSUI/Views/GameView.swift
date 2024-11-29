import SwiftUI
import SpriteKit

struct GameView: View {
    
    var body: some View {
        GeometryReader { geometry in
            SpriteKitView(size: geometry.size)
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }
}


struct SpriteKitView: UIViewRepresentable {
    let size: CGSize
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.showsPhysics = true
        skView.showsFPS = true

        // Load the scene from the SKS file
        let sceneName = "Level1"
        guard let gameScene = SKScene(fileNamed: sceneName) as? GameScene else {
            fatalError("Could not load GameScene from file")
        }
        gameScene.scaleMode = .aspectFit
        gameScene.size = size
        // Inject dependencies
        let playerData = PlayerData()
        gameScene.playerData = playerData
        gameScene.entityManager = DependencyFactory.createEntityManager(scene: gameScene)
        gameScene.touchHandler = DependencyFactory.createSceneTouchHandler(type: .gameScene)
        gameScene.contactHandler = DependencyFactory.createSceneContactHandler(type: .gameScene)

        gameScene.touchHandler.setScene(gameScene)
        gameScene.contactHandler.setScene(gameScene)

        // Configure and present the scene
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update logic, if needed
    }
}

