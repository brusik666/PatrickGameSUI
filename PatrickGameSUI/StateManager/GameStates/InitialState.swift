import SpriteKit

class InitialState: GameState {
    
    
    func enterState(scene: GameScene) {
        
        scene.uiCreator.createUI()
        let tutorNode = TutorialNode(text: "ASDASDASD")
        tutorNode.name = "tutorialNode"
        tutorNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        scene.addChild(tutorNode)
        tutorNode.startExplain {
            GameStateManager.shared.transition(to: GameHasStartedState(), scene: scene)
        }
        
    }
    
    func exitState(scene: GameScene) {
        scene.camera?.children.forEach({$0.isUserInteractionEnabled = false})
        scene.camera?.childNode(withName: UIElementsNames.joystick.rawValue)?.isUserInteractionEnabled = true
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        //
    }
    
}
