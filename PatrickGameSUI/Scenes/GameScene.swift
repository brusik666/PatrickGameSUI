
import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    //weak var gameOverDelegate: GameOverDelegate?
    //weak var homeButtonDelegate: HomeButtonDelegate?
    var entityManager: EntityManager?
    var startTouchLocation: CGPoint?
    
    override init(size: CGSize) {
        super.init(size: size)
        self.entityManager = DependencyFactory.createEntityManager(scene: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.entityManager = DependencyFactory.createEntityManager(scene: self)
    }
}

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        GameStateManager.shared.update(deltaTime: currentTime, scene: self)
        entityManager?.update(currentTime)
    }
    
    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
        physicsWorld.contactDelegate = self
       // physicsWorld.gravity = .zero
        backgroundColor = .white
        GameStateManager.shared.transition(to: InitialState(), scene: self)
        view.showsPhysics = true
        
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        //self.contactHandler.takeContact(contact: contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        //self.contactHandler.endContact(contact: contact)
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        //touchHandler.handleTouch(touch: touch)
        let location = touch.location(in: self)
        startTouchLocation = location
        let screenWidth = self.size.width
                
                // Check if the touch is on the right or left side of the screen
        if location.x > screenWidth / 2 {
                    // Right side: increase speed
            if let movementComponent = entityManager?.player.component(ofType: PlayerMovementComponent.self) {
                movementComponent.increaseSpeed()
            }
        } else {
                    // Left side: decrease speed
            if let movementComponent = entityManager?.player.component(ofType: PlayerMovementComponent.self) {
                        movementComponent.slowDown()
            }
        
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        //touchHandler.handleTouch(touch: touch)
        let endTouchLocation = touch.location(in: self)
        
        // Check if it was a bottom-to-top swipe
        if let startLocation = startTouchLocation {
            let swipeDistanceY = endTouchLocation.y - startLocation.y
            let swipeDistanceX = abs(endTouchLocation.x - startLocation.x)
            
            // Define a threshold to determine if the swipe is large enough
            let swipeThreshold: CGFloat = 50.0
            
            // Check if the vertical swipe distance is greater than the threshold, and the vertical distance is greater than horizontal
            if swipeDistanceY > swipeThreshold && swipeDistanceY > swipeDistanceX {
                // Trigger the player's jump
                if let jumpComponent = entityManager?.player.component(ofType: JumpComponent.self) {
                    print("JUMP")
                    jumpComponent.jump()
                }
            }
        }
        
        // Reset the start touch location
        startTouchLocation = nil
    }
}
