import SpriteKit

class InitialState: GameState {
    
    let meteorDropper: MeteorDroppingService
    
    init(meteorDropper: MeteorDroppingService) {
        self.meteorDropper = meteorDropper
    }
    
    func enterState(scene: GameScene) {
        let uiCreator = DependencyFactory.createSceneUICreator(type: .gameScene)
        uiCreator.setScene(scene)
        uiCreator.createUI()
        
        let heightMultiplier: CGFloat = 4
        let player = EntitiesFactory.createPlayerEntity(type: .origin, height: scene.size.height / heightMultiplier)

        scene.entityManager?.player = player
        scene.entityManager?.addEntity(entity: player)
        let timeBarController = TimeBarController(timeBar: scene.evasionTimerBar)
        meteorDropper.startDropMeteors()
        
    }
    
    func exitState(scene: GameScene) {
        //scene.camera?.children.forEach({$0.isUserInteractionEnabled = false})
        //scene.camera?.childNode(withName: UIElementsNames.joystick.rawValue)?.isUserInteractionEnabled = true
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        let playerPosition = scene.entityManager?.player?.component(ofType: SpriteComponent.self)?.node.position ?? .zero
        
        let cameraXPositionOffset = scene.size.width / 3
        let cameraYPositionOffset = scene.size.height / 4
        scene.camera?.position = CGPoint(
            x: playerPosition.x + cameraXPositionOffset,
            y: playerPosition.y + cameraYPositionOffset)
        meteorDropper.update(deltaTime: deltaTime)
        guard let pointsManager = scene.gamePointsManager else { return }
        pointsManager.updatePlayerProgress(playerXPosition: playerPosition.x)
        //scene.camera?.position = playerPosition
    }
}


