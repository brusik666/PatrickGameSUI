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
    
    func exploid() {
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
        //spriteNode.scene?.run(.playSoundFileNamed("explosion", waitForCompletion: false))
        spriteNode.physicsBody = nil
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: explodeDuration), SKAction.removeFromParent()])
        particle.run(removeAction)
        //spriteNode.run(SKAction.sequence([updateShaderTime, SKAction.removeFromParent()]))
    }
    
    private func removeFromEntity() {
        if let entity = self.entity,
           let gameScene = entity.component(ofType: SpriteComponent.self)?.node.scene as? GameScene {
            gameScene.entityManager?.removeEntity(entity: entity)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
