import SpriteKit

protocol Exploidable {
    func exploid()
}

extension Exploidable where Self: SKSpriteNode {
    func exploid() {
        let particleName = "Explosion"
        guard let particle = SKEmitterNode(fileNamed: particleName) else { return }
        particle.targetNode = self
        particle.position = self.position
        particle.zPosition = 1000
        particle.particleAlpha = 0.5
        particle.particleColorBlendFactor = 1
        particle.particleColor = .systemRed
        self.scene?.addChild(particle)
        self.scene?.run(.playSoundFileNamed("explosion", waitForCompletion: false))
        self.physicsBody = nil
        let duration = 0.5
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: duration), SKAction.removeFromParent()])
        particle.run(removeAction)
        
    }
}
