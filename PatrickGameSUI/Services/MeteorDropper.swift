import SpriteKit
import GameplayKit

class MeteorDropper {
    private let scene: GameScene
    private let player: SKNode // Reference to the player node or a way to get player position
    private var meteorTypes: [MeteorType]
    private var dropInterval: TimeInterval
    private var maxMeteors: Int
    private var activeMeteors: [Meteor] = []
    
    init(scene: GameScene, player: SKNode, meteorTypes: [MeteorType], dropInterval: TimeInterval, maxMeteors: Int) {
        self.scene = scene
        self.player = player
        self.meteorTypes = meteorTypes
        self.dropInterval = dropInterval
        self.maxMeteors = maxMeteors
        setupDropTimer()
    }
    
    private func setupDropTimer() {
        let dropAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            // Get the player's current position
            let playerPosition = self.player.position
            self.dropMeteorWithAngle(playerPosition: playerPosition)
        }
        
        let waitAction = SKAction.wait(forDuration: dropInterval)
        let sequence = SKAction.sequence([dropAction, waitAction])
        scene.run(SKAction.repeatForever(sequence))
    }
    
    private func dropMeteorWithAngle(playerPosition: CGPoint) {
        guard activeMeteors.count < maxMeteors else { return }
        
        // Randomly select a meteor type
        let meteorType = meteorTypes.randomElement()!
        
        // Set spawn position relative to the player’s current position
        let spawnRange: CGFloat = 400
        let startX = CGFloat.random(in: (playerPosition.x + 200)...(playerPosition.x + spawnRange))
        let startY = playerPosition.y + scene.size.height // Drop from above the player
        
        let startPosition = CGPoint(x: startX, y: startY)
        
        // Create meteor entity using the factory
        let meteor = EntitiesFactory.createMeteorEntity(type: meteorType, position: startPosition)
        
        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
            
            // Apply initial impulse with stronger horizontal push
            let initialHorizontalImpulse = CGFloat.random(in: -meteorType.speed * 200...meteorType.speed * 20)
            let initialVerticalImpulse = -meteorType.speed * 20
            spriteNode.physicsBody?.applyImpulse(CGVector(dx: initialHorizontalImpulse, dy: initialVerticalImpulse))
            
            // Apply continuous force to sustain the angle
            let continuousForce = SKAction.applyForce(CGVector(dx: initialHorizontalImpulse / 2, dy: initialVerticalImpulse / 2), duration: 5.0)
            spriteNode.run(continuousForce)
            
            activeMeteors.append(meteor)
        }
    }



    
    // Optional: Clean up meteors that fall out of view or are no longer needed
    func removeMeteor(_ meteor: Meteor) {
        meteor.component(ofType: SpriteComponent.self)?.node.removeFromParent()
        activeMeteors.removeAll { $0 == meteor }
    }
}
