import SpriteKit

class InitialState: GameState {
    
    let meteorDropper: MeteorDroppingService
    let pointsCounter: PointsCounter
    
    init(meteorDropper: MeteorDroppingService, pointsCounter: PointsCounter) {
        self.meteorDropper = meteorDropper
        self.pointsCounter = pointsCounter
    }
    
    func enterState(scene: GameScene) {
        let uiCreator = DependencyFactory.createSceneUICreator(type: .gameScene)
        uiCreator.setScene(scene)
        uiCreator.createUI()
        
        let heightMultiplier: CGFloat = 4
        let player = EntitiesFactory.createPlayerEntity(type: .origin, height: scene.size.height / heightMultiplier)

        //let coin = Coin()
        //scene.entityManager?.addEntity(entity: coin)
        scene.entityManager?.player = player
        scene.entityManager?.addEntity(entity: player)
        meteorDropper.startDropMeteors()
        startTimerActions(scene: scene)
        
    }
    
    func exitState(scene: GameScene) {
        //scene.camera?.children.forEach({$0.isUserInteractionEnabled = false})
        //scene.camera?.childNode(withName: UIElementsNames.joystick.rawValue)?.isUserInteractionEnabled = true
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        let playerPosition = scene.entityManager?.player?.component(ofType: SpriteComponent.self)?.node.position ?? .zero
        
        let cameraXPositionOffset = scene.size.width / 4
        let cameraYPositionOffset = scene.size.height / 4
        scene.camera?.position = CGPoint(
            x: playerPosition.x + cameraXPositionOffset,
            y: playerPosition.y + cameraYPositionOffset)
        meteorDropper.update(deltaTime: deltaTime)
        guard let node = scene.camera?.childNode(withName: "meteorRoomNode") as? MeteorRoomNode else { return }

    }
    
    private func startTimerActions(scene: GameScene) {
        scene.mainLabel.position.y += scene.size.height * 0.4
        scene.mainLabel.text = ""
        scene.mainLabel.isHidden = false
        var pointsCollected = 0
        scene.mainLabel.text = String(pointsCollected)
        let w8 = SKAction.wait(forDuration: 1)
        let block = SKAction.run {
            pointsCollected += 10
            scene.mainLabel.text = String(pointsCollected)
        }
        let sequence = SKAction.sequence([w8, block])
        scene.run(.sequence([.repeatForever(sequence), .run {
            //GameStateManager.shared.transition(to: GameHasFinishedState(isWin: false), scene: scene)
        }]))
        
    }
    
}


