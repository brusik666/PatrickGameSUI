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
    private let meteorManager = MeteorManager()
    private let targetingProbability: CGFloat = 0.7 // 70% chance to target player
    
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
            Task {
                if let playerPosition = await self.entityManager?.player?.component(ofType: SpriteComponent.self)?.node.position {
                    await self.dropMeteor()
                }
            }
        }
        
        let waitAction = SKAction.wait(forDuration: dropInterval)
        let sequence = SKAction.sequence([dropAction, waitAction])
        scene.run(SKAction.repeatForever(sequence))
    }
    
    func update(deltaTime: TimeInterval) {
        Task {
            let visibleBounds = getVisibleScreenBounds()
            let meteors = await meteorManager.getActiveMeteors()
            
            for meteor in meteors {
                if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
                    if await !visibleBounds.contains(spriteNode.position) {
                        if await meteorManager.removeMeteor(meteor) {
                            entityManager?.removeEntity(entity: meteor)
                            //print("Meteor removed from UPDATE")
                        }
                    }
                }
            }
        }
    }

    @MainActor
    private func dropMeteor() async {
        let activeMeteors = await meteorManager.getActiveMeteors()
        guard activeMeteors.count < maxMeteors else { return }

        let meteorType = meteorTypes.randomElement()!
        let meteor = await meteorManager.getPooledMeteor(ofType: meteorType)
            ?? EntitiesFactory.createMeteorEntity(type: meteorType, position: .zero)

        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent() // Ensure it's removed before reuse
            spriteNode.physicsBody?.velocity = .zero // Reset physics state
            spriteNode.position = .zero // Reset position
        }

        entityManager?.addEntity(entity: meteor)

        if let spriteNode = meteor.component(ofType: SpriteComponent.self)?.node {
            // Get visible bounds with a buffer just above the screen
            let visibleBounds = getVisibleScreenBounds(withBuffer: 100) // Buffer of 100 pixels above
            let spawnX = CGFloat.random(in: visibleBounds.minX...visibleBounds.maxX)
            let spawnY = visibleBounds.maxY // Just above the visible screen area
            let spawnPosition = CGPoint(x: spawnX, y: spawnY)
            spriteNode.position = spawnPosition

            // Random target position at the bottom of the screen
            let targetX = CGFloat.random(in: visibleBounds.minX...visibleBounds.maxX)
            let targetPosition = CGPoint(x: targetX, y: visibleBounds.minY)

            let vector = calculateForceVector(from: spawnPosition, to: targetPosition, forceMagnitude: 7000)
            spriteNode.physicsBody?.applyImpulse(vector)
            await meteorManager.addMeteor(meteor)
        }
    }


    
    func removeMeteor(_ meteor: Meteor) {
        Task {
            if await meteorManager.removeMeteor(meteor) {
                entityManager?.removeEntity(entity: meteor)
                //print("Meteor removed manually")
            }
        }
    }
    
    private func calculateForceVector(from startPosition: CGPoint, to targetPosition: CGPoint, forceMagnitude: CGFloat) -> CGVector {
        let dx = targetPosition.x - startPosition.x
        let dy = targetPosition.y - startPosition.y
        let distance = sqrt(dx * dx + dy * dy)
        let normalizedDx = dx / distance
        let normalizedDy = dy / distance
        return CGVector(dx: normalizedDx * forceMagnitude, dy: normalizedDy * forceMagnitude / 20)
    }
    
    private func getVisibleScreenBounds(withBuffer buffer: CGFloat = 300) -> CGRect {
        guard let camera = scene.camera else { return scene.frame }
        
        let cameraPosition = camera.position
        let halfWidth = scene.size.width / 2
        let halfHeight = scene.size.height / 2
        
        return CGRect(
            x: cameraPosition.x - halfWidth - buffer,
            y: cameraPosition.y - halfHeight - buffer,
            width: scene.size.width + buffer * 4,
            height: scene.size.height + buffer * 2
        )
    }
}

