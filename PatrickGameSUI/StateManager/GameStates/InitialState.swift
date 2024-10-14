import SpriteKit

class InitialState: GameState {
    
    
    func enterState(scene: GameScene) {
        
        scene.uiCreator.createUI()
        //
        
    }
    
    func exitState(scene: GameScene) {
        scene.camera?.children.forEach({$0.isUserInteractionEnabled = false})
        scene.camera?.childNode(withName: UIElementsNames.joystick.rawValue)?.isUserInteractionEnabled = true
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        //
    }
    
}
