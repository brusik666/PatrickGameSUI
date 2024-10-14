import SpriteKit

protocol GameState {
    
    func enterState(scene: GameScene)
    func exitState(scene: GameScene)
    func update(deltaTime: TimeInterval, scene: GameScene)
}


