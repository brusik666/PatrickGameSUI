import SpriteKit

class InitialState: GameState {
    
    var meteorCreator: MeteorDropper!
    
    func enterState(scene: GameScene) {
        let uiCreator = DependencyFactory.createSceneUICreator(type: .gameScene)
        uiCreator.setScene(scene)
        uiCreator.createUI()
        
        let player = EntitiesFactory.createPlayerEntity(type: .origin)
        let meteorPosition = CGPoint(x: scene.frame.maxX * 0.8, y: scene.size.height)
        let meteor = EntitiesFactory.createMeteorEntity(type: .mediumMeteor, position: meteorPosition)
        let coin = Coin()
        scene.entityManager?.addEntity(entity: meteor)
        scene.entityManager?.addEntity(entity: coin)
        scene.entityManager?.player = player
        scene.entityManager?.addEntity(entity: player)
        guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }
        meteorCreator = MeteorDropper(scene: scene, player: playerNode, meteorTypes: [.bigMeteor, .mediumMeteor, .smallMeteor], dropInterval: 1, maxMeteors: 100)
        
        
    }
    
    func exitState(scene: GameScene) {
        //scene.camera?.children.forEach({$0.isUserInteractionEnabled = false})
        //scene.camera?.childNode(withName: UIElementsNames.joystick.rawValue)?.isUserInteractionEnabled = true
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        scene.camera?.position = scene.entityManager?.player.component(ofType: SpriteComponent.self)?.node.position ?? .zero
    }
    
}
