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
    

    // Async function that awaits completion after running the animation
    func exploid(completion: @escaping () -> Void) {
        let particleName = type.rawValue
        guard let particle = SKEmitterNode(fileNamed: particleName),
              let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else { return }

        let explodeDuration: CGFloat = 0.2

        particle.targetNode = spriteNode
        particle.position = spriteNode.position
        particle.zPosition = 1000
        particle.particleAlpha = 0.5
        particle.particleColorBlendFactor = 1
        particle.particleColor = .systemRed
        spriteNode.scene?.addChild(particle)

        //spriteNode.physicsBody = nil

        particle.run(.sequence([.wait(forDuration: explodeDuration), .removeFromParent()]), completion: completion)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
