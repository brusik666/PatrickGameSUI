//
//  MeteorSensorNode.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/26/24.
//

import SpriteKit

class MeteorDetectionNode: SKNode {
    
    init(height: CGFloat) {
        super.init()
        setupPhysicsBody(height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupPhysicsBody(height: CGFloat) {
        let body = PhysicBodyBuilder()
            .withCircle(height: height)
            .setIsDynamic(false)
            .setPhysicsCategories(mask: PhysicsCategory.meteorSensor, collision: [], contact: [PhysicsCategory.meteor])
            .setAffectedByGravity(false)
            .build()
        physicsBody = body
    }
}
