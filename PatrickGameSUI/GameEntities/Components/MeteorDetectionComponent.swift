//
//  MeteorDetectionComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/19/24.
//

import GameplayKit
import SpriteKit

class MeteorDetectionComponent: GKComponent {
    
    private var detectionNode: SKNode
    init(detectionNode: SKNode, height: CGFloat) {
        self.detectionNode = detectionNode
        super.init()
        setupPhysicsBody(height: height)
    }
    
    override func didAddToEntity() {
        guard let playerNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            print("Error: SpriteComponent or its node is missing.")
            return
        }
        playerNode.addChild(detectionNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody(height: CGFloat) {
        let body = PhysicBodyBuilder()
            .withCircle(height: height)
            .setIsDynamic(false)
            .setPhysicsCategories(mask: PhysicsCategory.meteorSensor, collision: [], contact: [PhysicsCategory.meteor])
            .setAffectedByGravity(false)
            .build()
        detectionNode.physicsBody = body
    }
}
