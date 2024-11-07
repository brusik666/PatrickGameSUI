//
//  ExplisionCreator.swift
//  RoyalVegas2
//
//  Created by Brusik on 15.05.2023.
//

import Foundation
import SpriteKit

class ExplosionCreator {
    static func createExplosion(in node: SKSpriteNode) {
        guard let particle = SKEmitterNode(fileNamed: "Explosion") else { return }
        particle.targetNode = node
        particle.position = node.position
        particle.zPosition = 1000
        particle.particleAlpha = 0.5
        particle.particleColorBlendFactor = 1
        particle.particleColor = .systemRed
        node.scene?.addChild(particle)
        
        let duration = 0.5
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: duration), SKAction.removeFromParent()])
        particle.run(removeAction)
        
    }
}
