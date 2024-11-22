import SpriteKit
import GameplayKit

protocol MeteorDroppingService {
    func startDropMeteors()
    func removeMeteor(_ meteor: Meteor)
    func update(deltaTime: TimeInterval)
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
    private let screenBounds: CGRect
    private let targetingProbability: CGFloat = 0.7 // 70% chance to target player

    init(scene: GameScene, meteorTypes: [MeteorType], dropInterval: TimeInterval, maxMeteors: Int) {
        self.scene = scene
        self.meteorTypes = meteorTypes
        self.dropInterval = dropInterval
        self.maxMeteors = maxMeteors
        self.entityManager = scene.entityManager
        self.screenBounds = UIScreen.main.bounds // Use screen bounds to determine spawn positions
    }
    
    func startDropMeteors() {
        let dropAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            if let playerPosition = self.entityManager?.player?.component(ofType: SpriteComponent.self)?.node.position {
                self.dropMeteor(playerPosition: playerPosition)
            }
        }
        
        let waitAction = SKAction.wait(forDuration: dropInterval)
        let sequence = SKAction.sequence([dropAction, waitAction])
        scene.run(SKAction.repeatForever(sequence))
    }
    
    func update(deltaTime: TimeInterval) {
        // Remove meteors outside the screen or no longer visible
        activeMeteors.forEach { meteor in
            
            if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
                print(spriteNode.position.y, "met pos")
                print(screenBounds.minY, "minY")
                if spriteNode.position.y < screenBounds.minY {
                    removeMeteor(meteor)
                }
            }
        }
    }
    
    private func dropMeteor(playerPosition: CGPoint) {
        guard activeMeteors.count < maxMeteors else { return }
        print(screenBounds, "screen bounds")
        
        let meteorType = meteorTypes.randomElement()!
        let meteor = getMeteor(ofType: meteorType)
        
        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            // Determine spawn position
            let spawnX = CGFloat.random(in: screenBounds.minX...screenBounds.maxX)
            let spawnPosition = CGPoint(x: spawnX, y: screenBounds.maxY)
            spriteNode.position = spawnPosition
            
            // Determine target position
            let targetPosition: CGPoint
            if CGFloat.random(in: 0...1) < targetingProbability {
                targetPosition = playerPosition // Target the player
            } else {
                // Random target position near the bottom
                let randomX = CGFloat.random(in: screenBounds.minX...screenBounds.maxX)
                targetPosition = CGPoint(x: randomX, y: screenBounds.minY)
            }
            
            // Calculate force vector and apply impulse
            let vector = calculateForceVector(from: spawnPosition, to: targetPosition, forceMagnitude: 7000)
            spriteNode.physicsBody?.applyAngularImpulse(0.5)
            spriteNode.physicsBody?.applyImpulse(vector)
            activeMeteors.insert(meteor)
        }
    }
    
    private func getMeteor(ofType type: MeteorType) -> Meteor {
        let meteor: Meteor
        if let pooledMeteor = meteorPool.popFirst() {
            meteor = pooledMeteor
            resetMeteor(meteor)
        } else {
            meteor = EntitiesFactory.createMeteorEntity(type: type, position: .zero)
            entityManager?.addEntity(entity: meteor)
        }
        return meteor
    }
    
    private func resetMeteor(_ meteor: Meteor) {
        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            spriteNode.position = .zero
            spriteNode.physicsBody?.velocity = .zero
            spriteNode.isHidden = false
        }
    }
    
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
    
    private func calculateForceVector(from startPosition: CGPoint, to targetPosition: CGPoint, forceMagnitude: CGFloat) -> CGVector {
        let dx = targetPosition.x - startPosition.x
        let dy = targetPosition.y - startPosition.y
        
        let distance = sqrt(dx * dx + dy * dy)
        let normalizedDx = dx / distance
        let normalizedDy = dy / distance
        
        return CGVector(dx: normalizedDx * forceMagnitude, dy: normalizedDy * forceMagnitude)
    }
}
