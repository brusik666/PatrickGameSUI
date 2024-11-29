import SpriteKit

protocol SceneTouchHandler {
    func handleTouch(touch: UITouch)
    func setScene(_ scene: SKScene)
}

class GameSceneTouchHandler: SceneTouchHandler {
    
    private weak var scene: GameScene?
    private var startTouchLocation: CGPoint?
    private var isSwipe: Bool = false
    lazy private var touchActions: [String: () -> Void] = [
        "" : {}
    ]
    
    func setScene(_ scene: SKScene) {
        guard let gameScene = scene as? GameScene else { return }
        self.scene = gameScene
    }
    
    func handleTouch(touch: UITouch) {
        guard let gameScene = scene else { return }
        let touchLocation = touch.location(in: gameScene)
        
        if touch.phase == .began {
            startTouchLocation = touchLocation
            isSwipe = false  // Reset the swipe flag
        } else if touch.phase == .ended {
            handleTouchesEndActions(endLocation: touchLocation)
        }
    }
    
    private func handleTouchesEndActions(endLocation: CGPoint) {
        guard let startLocation = startTouchLocation else { return }
        let gesture = detectGesture(from: startLocation, to: endLocation)
        
        if gesture != .none {
            isSwipe = true  // Mark as swipe if a swipe gesture is detected
        }
        
        // Handle swipe or tap actions based on `isSwipe` status
        if isSwipe {
            handleSwipeAction(for: gesture)
        } else {
            handleTapAction(at: endLocation)
        }
        
        resetTouch()
    }
    
    private func handleSwipeAction(for gesture: GestureDirection) {
        switch gesture {
        case .up:
            triggerJump(isSuperJump: false)
        case .superUp:
            triggerJump(isSuperJump: true)
        case .down:
            triggerLand()
        case .left:
            break
        case .right:
            break
        case .none:
            break
        }
    }
    
    private func handleTapAction(at location: CGPoint) {
        guard let gameScene = scene,
              let playerMoveComponent = gameScene.entityManager?.player?.component(ofType: PlayerMovementComponent.self),
              let sceneView = gameScene.view else { return }
        
        let screenTouchLocation = sceneView.convert(location, from: gameScene)
        let screenWidth = sceneView.bounds.width
        
        // Adjust speed based on tap location
        if screenTouchLocation.x < screenWidth / 2 {
            playerMoveComponent.slowDown()
        } else {
            playerMoveComponent.increaseSpeed()
            gameScene.combinationProgressBar.decreaseProgress(over: 3)
        }
    }
}

extension GameSceneTouchHandler {
    
    private func triggerJump(isSuperJump: Bool) {
        guard let scene = scene,
              let jumpComponent = scene.entityManager?.player?.component(ofType: JumpComponent.self) else { return }
        
        jumpComponent.jump(isSuperJump: isSuperJump)
        resetTouch()
    }
    
    private func triggerLand() {
        guard let scene = scene,
              let jumpComponent = scene.entityManager?.player?.component(ofType: JumpComponent.self) else { return }
        
        jumpComponent.land() // Call the land method on the JumpComponent
        resetTouch() // Reset touch state after the action
    }

    
    private func resetTouch() {
        startTouchLocation = nil
        isSwipe = false
    }
    
    private func detectGesture(from start: CGPoint, to end: CGPoint) -> GestureDirection {
        guard let gameScene = scene else { fatalError() }
        let deltaY = end.y - start.y
        let deltaX = end.x - start.x
        let sceneHeight = gameScene.size.height
        let verticalThreshold: CGFloat = sceneHeight / 4
        let superVerticalThreshold: CGFloat = sceneHeight / 2
        let horizontalThreshold: CGFloat = verticalThreshold

        if abs(deltaY) > abs(deltaX) {
            if deltaY > superVerticalThreshold {
                return .superUp
            } else if deltaY > verticalThreshold {
                return .up
            } else if deltaY < -verticalThreshold {
                return .down // Detect downward swipe
            }
        } else {
            if deltaX > horizontalThreshold {
                return .right
            } else if deltaX < -horizontalThreshold {
                return .left
            }
        }
        return .none
    }

}

extension GameSceneTouchHandler {
    enum GestureDirection {
        case up
        case superUp
        case down
        case left
        case right
        case none
    }
}

