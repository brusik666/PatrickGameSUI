
import SpriteKit

protocol SceneTouchHandler {
    func handleTouch(touch: UITouch)
    func setScene(_ scene: SKScene)
}

class GameSceneTouchHandler: SceneTouchHandler {
    private weak var scene: GameScene?
    
    func setScene(_ scene: SKScene) {
        guard let gameScene = scene as? GameScene else { return }
        self.scene = gameScene
    }
    
    func handleTouch(touch: UITouch) {

        guard let gameScene = scene else { return }
        let touchLocation = touch.location(in: gameScene)
        let touchedNode = gameScene.atPoint(touchLocation)
        
        guard let name = touchedNode.name else { return }
        
        if touch.phase == .began {
            handleTouchesBeganActions(name)
        } else if touch.phase == .ended {
            handleTouchesEndActions(name)
        }
    }
    
    private func handleTouchesBeganActions(_ nodeName: String) {
        guard let gameScene = scene else { return }
        switch nodeName {
            
        case UIElementsNames.fireLeftButton.rawValue:
            gameScene.player.simpleShot(direction: .left)
            
        case UIElementsNames.fireRightButton.rawValue:
            gameScene.player.simpleShot(direction: .right)
            
        case UIElementsNames.dropMineButton.rawValue:
            gameScene.player.dropMine()
            
        case UIElementsNames.dropBombButton.rawValue:
            gameScene.player.dropBomb()
            
        case UIElementsNames.fuelButton.rawValue:
            guard gameScene.gasolineNode.labelNode.count > 0 else { return }
            gameScene.gasolineNode.fullIncrease()
            gameScene.gasolineNode.labelNode.count -= 1
            
        case UIElementsNames.repairButton.rawValue:
            guard gameScene.receivedDamageNode.labelNode.count > 0 else { return }
            gameScene.receivedDamageNode.fullIncrease()
            gameScene.receivedDamageNode.labelNode.count -= 1
            
        case UIElementsNames.homeButton.rawValue:
            gameScene.homeButtonDelegate?.homeButtonTapped()
        default: break
        }
    }
    
    
    
    private func handleTouchesEndActions(_ nodeName: String) {
        guard let gameScene = scene else { return }
        switch nodeName {
        default: break
        }
    }
    
    
}

