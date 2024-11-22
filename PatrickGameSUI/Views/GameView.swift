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
        let playerData = PlayerData()
        let gameScene = GameScene(size: size, playerData: playerData)
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update logic, if needed
    }
}

