//
//  ExplosionComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/4/24.
//

import Foundation
import GameplayKit

enum ExplosionType: String {
    case basicExplosion
}

class ExplosionComponent: GKComponent {
    
    let type: ExplosionType
    
    init(explosionType: ExplosionType) {
        self.type = explosionType
        super.init()
    }
    
    // Helper function to run SKAction without any async behavior
    func runExplosionAnimation(on particle: SKEmitterNode, with duration: CGFloat) {
        let removeAction = SKAction.sequence([
            SKAction.wait(forDuration: duration),
            SKAction.removeFromParent()
        ])
        particle.run(removeAction)
    }

    // Async function that awaits completion after running the animation
    @MainActor
    func exploid() async {
        let particleName = type.rawValue
        guard let particle = SKEmitterNode(fileNamed: particleName),
              let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else { return }

        let explodeDuration: CGFloat = 0.25

        particle.targetNode = spriteNode
        particle.position = spriteNode.position
        particle.zPosition = 1000
        particle.particleAlpha = 0.5
        particle.particleColorBlendFactor = 1
        particle.particleColor = .systemRed
        spriteNode.scene?.addChild(particle)

        spriteNode.physicsBody = nil

        // Run SKAction animation in a separate, synchronous function
        runExplosionAnimation(on: particle, with: explodeDuration)

        // Wait asynchronously for the explosion duration
        try? await Task.sleep(nanoseconds: UInt64(explodeDuration * 1_000_000_000))
    }

    
    private func removeEntity() {
        if let entity = self.entity,
           let gameScene = entity.component(ofType: SpriteComponent.self)?.node.scene as? GameScene {
            gameScene.entityManager?.removeEntity(entity: entity)
            print("removed")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
