import SpriteKit
import GameplayKit

protocol MeteorDroppingService {
    func startDropMeteors()
    func removeMeteor(_ meteor: Meteor)
}

class MeteorDropper: MeteorDroppingService {
    private let scene: GameScene
    private var entityManager: EntityController?
    private var meteorTypes: [MeteorType]
    private var dropInterval: TimeInterval
    private var maxMeteors: Int
    private var activeMeteors: [Meteor] = []
    
    init(scene: GameScene, meteorTypes: [MeteorType], dropInterval: TimeInterval, maxMeteors: Int) {
        self.scene = scene
        self.meteorTypes = meteorTypes
        self.dropInterval = dropInterval
        self.maxMeteors = maxMeteors
        self.entityManager = scene.entityManager
    }
    
    func startDropMeteors() {
        let dropAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            if let playerPosition = scene.entityManager?.player?.component(ofType: SpriteComponent.self)?.node.position {
                self.dropMeteor(playerPosition: playerPosition)
            }
            
        }
        
        let waitAction = SKAction.wait(forDuration: dropInterval)
        let sequence = SKAction.sequence([dropAction, waitAction])
        scene.run(SKAction.repeatForever(sequence))
    }
    
    private func dropMeteor(playerPosition: CGPoint) {
        guard activeMeteors.count < maxMeteors else { return }
        
        let meteorType = meteorTypes.randomElement()!
        
        let spawnRange: CGFloat = 400
        let startX = CGFloat.random(in: (playerPosition.x + 200)...(playerPosition.x + spawnRange))
        let startY = playerPosition.y + scene.size.height
        
        let startPosition = CGPoint(x: startX, y: startY)
        
        let meteor = EntitiesFactory.createMeteorEntity(type: meteorType, position: startPosition)
        entityManager?.addEntity(entity: meteor)
        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            
            let initialHorizontalImpulse = CGFloat.random(in: -meteorType.speed * 200...meteorType.speed * 20)
            let initialVerticalImpulse = -meteorType.speed * 200
            spriteNode.physicsBody?.applyImpulse(CGVector(dx: -5000, dy: -2500))
            activeMeteors.append(meteor)
            
        }
    }



    
    // Optional: Clean up meteors that fall out of view or are no longer needed
    func removeMeteor(_ meteor: Meteor) {
        activeMeteors.removeAll { $0 == meteor }
        entityManager?.removeEntity(entity: meteor)
    }
}
