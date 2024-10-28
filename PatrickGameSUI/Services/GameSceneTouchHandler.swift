//
//  GameSceneTouchHandler.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/26/24.
//

import SpriteKit

protocol SceneTouchHandler {
    func handleTouch(touch: UITouch)
    func setScene(_ scene: SKScene)
}

class GameSceneTouchHandler: SceneTouchHandler {
    
    private weak var scene: GameScene?
    private var startTouchLocation: CGPoint?
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
        let touchedNode = gameScene.atPoint(touchLocation)
        
        if let nodeName = touchedNode.name,
           let action = touchActions[nodeName] {
            action()
        }
        
        if touch.phase == .began {
            handleTouchesBeganActions()
            startTouchLocation = touchLocation
        } else if touch.phase == .ended {
            handleTouchesEndActions(endLocation: touchLocation)
        }
    }

    
    private func handleTouchesBeganActions() {
        guard let gameScene = scene else { return }
        
    }
    
    
    
    private func handleTouchesEndActions(endLocation: CGPoint) {
        guard let startLocation = startTouchLocation else { return }
        let gesture = detectGesture(from: startLocation, to: endLocation)
                
        switch gesture {
        case .up:
            triggerJump(isSuperJump: false)
        case .superUp:
            triggerJump(isSuperJump: true)
        case .down:
            break
        case .left:
            break
        case .right:
            break
        case .none:
            break
        }
        resetTouch()
    }
}

extension GameSceneTouchHandler {
    
    private func triggerJump(isSuperJump: Bool) {
        guard let scene = scene,
              let jumpComponent = scene.entityManager?.player.component(ofType: JumpComponent.self) else { return }
        
        jumpComponent.jump(isSuperJump: isSuperJump)
        resetTouch()
    }
    
    private func resetTouch() {
        startTouchLocation = nil
    }
    
    private func detectGesture(from start: CGPoint, to end: CGPoint) -> GestureDirection {
        guard let gameScene = scene else { fatalError()}
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
                return .down
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

