
import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    //weak var gameOverDelegate: GameOverDelegate?
    //weak var homeButtonDelegate: HomeButtonDelegate?
    var entityManager: EntityManager?
    var touchHandler: SceneTouchHandler
    var contactHandler: SceneContactHandler
    
    override init(size: CGSize) {
        self.contactHandler = DependencyFactory.createSceneContactHandler(type: .gameScene)
        self.touchHandler = DependencyFactory.createSceneTouchHandler(type: .gameScene)
        super.init(size: size)
        self.entityManager = DependencyFactory.createEntityManager(scene: self)
        touchHandler.setScene(self)
        contactHandler.setScene(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.contactHandler = DependencyFactory.createSceneContactHandler(type: .gameScene)
        self.touchHandler = DependencyFactory.createSceneTouchHandler(type: .gameScene)
        super.init(coder: aDecoder)
        self.entityManager = DependencyFactory.createEntityManager(scene: self)
        touchHandler.setScene(self)
        contactHandler.setScene(self)
    }
}

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        GameStateManager.shared.update(deltaTime: currentTime, scene: self)
        entityManager?.update(currentTime)
    }
    
    override func didMove(to view: SKView) {
        setupSceneView(view)
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
        print("TOUCHES BEGAN")
        touchHandler.handleTouch(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        print("Touches ended")
        touchHandler.handleTouch(touch: touch)
    }
}

extension GameScene {
    private func setupSceneView(_ view: SKView) {
        view.isMultipleTouchEnabled = true
        physicsWorld.contactDelegate = self
       // physicsWorld.gravity = .zero
        backgroundColor = .white
        GameStateManager.shared.transition(to: InitialState(), scene: self)
        view.showsPhysics = true
        name = "asd"
    }
}
