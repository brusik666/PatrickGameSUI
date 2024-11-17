//
//  ParticleTrailComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/4/24.
//

import Foundation
import GameplayKit
import SpriteKit

enum ParticleTrailType: String {
    case basicTrail
    case spark
}

class ParticleTrailComponent: GKComponent {
    
    private let particleEmitter: SKEmitterNode
    private weak var targetNode: SKSpriteNode?
    
    init(type: ParticleTrailType, targetNode: SKSpriteNode) {
        guard let emitter = SKEmitterNode(fileNamed: type.rawValue) else { fatalError("no such particle") }
        particleEmitter = emitter
        self.targetNode = targetNode
        
        particleEmitter.position = CGPoint(x: 0, y: -targetNode.size.height / 2)
        particleEmitter.zPosition = 4
        super.init()
        targetNode.addChild(particleEmitter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        particleEmitter.removeFromParent()
    }
}
