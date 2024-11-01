import SpriteKit

class InitialState: GameState {
    
    
    func enterState(scene: GameScene) {
        let uiCreator = DependencyFactory.createSceneUICreator(type: .gameScene)
        uiCreator.setScene(scene)
        uiCreator.createUI()
        
        let player = Player()
        let coin = Coin()
        scene.entityManager?.addEntity(entity: coin)
        scene.entityManager?.player = player
        scene.entityManager?.addEntity(entity: player)
        
    }
    
    func exitState(scene: GameScene) {
        //scene.camera?.children.forEach({$0.isUserInteractionEnabled = false})
        //scene.camera?.childNode(withName: UIElementsNames.joystick.rawValue)?.isUserInteractionEnabled = true
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        scene.camera?.position = scene.entityManager?.player.component(ofType: SpriteComponent.self)?.node.position ?? .zero
    }
    
}
