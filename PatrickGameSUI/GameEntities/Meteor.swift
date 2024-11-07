//
//  Meteor.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/31/24.
//

import Foundation
import  GameplayKit

class Meteor: GKEntity {
    
    init(type: MeteorType, position: CGPoint) {
        super.init()
        
        let spriteTexture = SKTexture(imageNamed: "dailyBonusButton")
        let heigt = CGFloat.random(in: 25...100)
        let spriteComponent = SpriteComponent(texture: spriteTexture, height: heigt, position: position)
        let spriteNode = spriteComponent.node
        spriteNode.entity = self
        spriteNode.physicsBody = PhysicBodyBuilder()
            .withTexture(spriteTexture, size: spriteNode.size)
            .setMass(type.mass)
            .setAllowsRotation(true)
            .setAffectedByGravity(true)
            .setIsDynamic(true)
            .setPhysicsCategories(mask: PhysicsCategory.meteor, collision: [PhysicsCategory.obstacles, PhysicsCategory.player], contact: [PhysicsCategory.player, PhysicsCategory.obstacles])
            .build()
        spriteNode.zPosition = ZPositions.meteor.rawValue
        addComponent(spriteComponent)
        
        let explosionComponent = ExplosionComponent(explosionType: .basicExplosion)
        addComponent(explosionComponent)
        
        let trailComponent = ParticleTrailComponent(type: .basicTrail, targetNode: spriteNode)
        addComponent(trailComponent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum MeteorType {
    case smallMeteor, mediumMeteor, bigMeteor
    
    var speed: CGFloat {
        switch self {
        case .smallMeteor:
            3
        case .mediumMeteor:
            2
        case .bigMeteor:
            1
        }
    }
    
    var textureName: String {
        switch self {
        case .smallMeteor:
            return ImageName.Entities.smallMeteor.rawValue
        case .mediumMeteor:
            return ImageName.Entities.mediumMeteor.rawValue
        case .bigMeteor:
            return ImageName.Entities.bigMeteor.rawValue
            
        }
    }
    
    var mass: CGFloat {
        switch self {
        case .smallMeteor:
            5
        case .mediumMeteor:
            10
        case .bigMeteor:
            20
        }
    }
}
