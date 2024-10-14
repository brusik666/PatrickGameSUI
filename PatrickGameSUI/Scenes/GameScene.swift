
import SpriteKit
import GameplayKit


class GameScene: SKScene {
    //weak var gameOverDelegate: GameOverDelegate?
    //weak var homeButtonDelegate: HomeButtonDelegate?
    
    var uiCreator: SceneUICreator
    var touchHandler: SceneTouchHandler
    var contactHandler: SceneContactHandler
    
    override init(size: CGSize) {
        self.uiCreator = DependencyFactory.createSceneUICreator(type: .gameScene)
        self.touchHandler = DependencyFactory.createSceneTouchHandler(type: .gameScene)
        self.contactHandler = DependencyFactory.createSceneContactHandler(type: .gameScene)
        super.init(size: size)
        uiCreator.setScene(self)
        contactHandler.setScene(self)
        touchHandler.setScene(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.uiCreator = DependencyFactory.createSceneUICreator(type: .gameScene)
        self.touchHandler = DependencyFactory.createSceneTouchHandler(type: .gameScene)
        self.contactHandler = DependencyFactory.createSceneContactHandler(type: .gameScene)
        super.init(coder: aDecoder)
        uiCreator.setScene(self)
        contactHandler.setScene(self)
        touchHandler.setScene(self)
        
    }
}

extension GameScene {
    
    /*override func update(_ currentTime: TimeInterval) {
        camera?.children.compactMap({$0 as? Updatable}).forEach({$0.update()})
        children.compactMap({$0 as? Updatable}).forEach({$0.update()})
        GameStateManager.shared.update(deltaTime: currentTime, scene: self)
    }
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        GameStateManager.shared.transition(to: InitialState(), scene: self)
        
        
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
    }*/
}
