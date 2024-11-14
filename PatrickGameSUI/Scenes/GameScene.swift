
import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    //weak var gameOverDelegate: GameOverDelegate?
    //weak var homeButtonDelegate: HomeButtonDelegate?
    var entityManager: EntityController?
    let playerData: PlayerData
    private var touchHandler: SceneTouchHandler
    private var contactHandler: SceneContactHandler
    var mainLabel: RoundedLabelNode!
    
    init(size: CGSize, playerData: PlayerData) {
        self.playerData = playerData
        self.contactHandler = DependencyFactory.createSceneContactHandler(type: .gameScene)
        self.touchHandler = DependencyFactory.createSceneTouchHandler(type: .gameScene)
        super.init(size: size)
        self.entityManager = DependencyFactory.createEntityManager(scene: self)
        touchHandler.setScene(self)
        contactHandler.setScene(self)
        
    }
    
    /*required init?(coder aDecoder: NSCoder, playerData: PlayerData) {
        self.playerData = playerData
        self.contactHandler = DependencyFactory.createSceneContactHandler(type: .gameScene)
        self.touchHandler = DependencyFactory.createSceneTouchHandler(type: .gameScene)
        super.init(coder: aDecoder)
        self.entityManager = DependencyFactory.createEntityManager(scene: self)
        touchHandler.setScene(self)
        contactHandler.setScene(self)
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        GameStateManager.shared.update(deltaTime: currentTime, scene: self)
        entityManager?.update(currentTime)
    }
    
    override func didMove(to view: SKView) {
        setupSceneView(view)
        playerData.coinsUpdated = { [weak self] newCount in
            self?.updateCoinLabel(with: newCount)
        }

    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        self.contactHandler.takeContact(contact: contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        self.contactHandler.endContact(contact: contact)
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchHandler.handleTouch(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchHandler.handleTouch(touch: touch)
    }
}

extension GameScene {
    private func setupSceneView(_ view: SKView) {
        view.isMultipleTouchEnabled = true
        physicsWorld.contactDelegate = self
       // physicsWorld.gravity = .zero
        backgroundColor = .white
        let meteorDropper = DependencyFactory.createMeteorDropper(scene: self)
        let pointsCounter = DependencyFactory.createPointsCounter()
        GameStateManager.shared.transition(to: InitialState(meteorDropper: meteorDropper, pointsCounter: pointsCounter), scene: self)
        view.showsPhysics = true
        view.showsFPS = true
        name = "asd"
    }
    
    private func updateCoinLabel(with count: Int) {
        let coinLabel = camera?.childNode(withName: "coinLabel") as! SKLabelNodeWithSprite
        coinLabel.labelNode.text = String(count)
    }
}
