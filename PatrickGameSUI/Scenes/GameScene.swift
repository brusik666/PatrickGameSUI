
import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    weak var gameOverDelegate: GameOverDelegate?
    //weak var homeButtonDelegate: HomeButtonDelegate?
    var entityManager: EntityController?
    var playerData: PlayerData!
    var touchHandler: SceneTouchHandler!
    var contactHandler: SceneContactHandler!
    var mainLabel: RoundedLabelNode!
    var messageLabel: RoundedLabelNode!
    var evasionTimerBar: TimeRemainBar!
    var gamePointsManager: PointsManager!
    private var timeBarController: TimeBarController?
    
}

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        GameStateManager.shared.update(deltaTime: currentTime, scene: self)
        entityManager?.update(currentTime)
    }
    
    override func didMove(to view: SKView) {
        setupSceneView(view)
        gamePointsManager.pointsUpdated = { [weak self] points in
            self?.updateMainLabel(with: points)
        }
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

        backgroundColor = .clear
        let meteorDropper = DependencyFactory.createMeteorDropper(scene: self)
        GameStateManager.shared.transition(to: InitialState(meteorDropper: meteorDropper), scene: self)
        view.showsPhysics = true
        view.showsFPS = true
        name = "asd"
        timeBarController = TimeBarController(timeBar: evasionTimerBar)
    }
    
    private func updateCoinLabel(with count: Int) {
        let coinLabel = camera?.childNode(withName: "coinLabel") as! SKLabelNodeWithSprite
        coinLabel.labelNode.text = String(count)
    }
    
    private func updateMainLabel(with points: Int) {
        mainLabel.text = String(points)
    }
}
