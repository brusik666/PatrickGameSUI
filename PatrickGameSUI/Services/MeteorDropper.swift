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
    private var activeMeteors: Set<Meteor> = [] {
        didSet {
            print(activeMeteors.count, "active meteors")
        }
    }
    private var meteorPool: Set<Meteor> = []
    
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
        let meteor = getMeteor(ofType: meteorType, playerPosition: playerPosition)
        
        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            spriteNode.physicsBody?.applyImpulse(CGVector(dx: -5000, dy: -2500))
            activeMeteors.insert(meteor) // Add to activeMeteors set
        }
    }
    
    private func getMeteor(ofType type: MeteorType, playerPosition: CGPoint) -> Meteor {
        let meteor: Meteor
        if let pooledMeteor = meteorPool.popFirst() { // Get a meteor from the set if available
            meteor = pooledMeteor
            resetMeteor(meteor, playerPosition: playerPosition)
        } else {
            let spawnRange: CGFloat = 400
            let startX = CGFloat.random(in: (playerPosition.x + 200)...(playerPosition.x + spawnRange))
            let startY = playerPosition.y + scene.size.height
            let startPosition = CGPoint(x: startX, y: startY)
            meteor = EntitiesFactory.createMeteorEntity(type: type, position: startPosition)
            entityManager?.addEntity(entity: meteor)
        }
        return meteor
    }
    
    private func resetMeteor(_ meteor: Meteor, playerPosition: CGPoint) {
        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            let spawnRange: CGFloat = 400
            let startX = CGFloat.random(in: (playerPosition.x + 200)...(playerPosition.x + spawnRange))
            let startY = playerPosition.y + scene.size.height
            spriteNode.position = CGPoint(x: startX, y: startY)
            spriteNode.physicsBody?.velocity = .zero
            spriteNode.isHidden = false
        }
    }



    
    // Optional: Clean up meteors that fall out of view or are no longer needed
    func removeMeteor(_ meteor: Meteor) {
        if activeMeteors.contains(meteor) {
            activeMeteors.remove(meteor)
            meteorPool.insert(meteor)
            if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
                spriteNode.isHidden = true
            }
            entityManager?.removeEntity(entity: meteor)
        }
    }
}
