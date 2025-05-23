//
//  Player.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//

import Foundation
import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    init(height: CGFloat) {
        super.init()
        
        let playerHeight: CGFloat = height
        let playerSpriteTexture = SKTexture(imageNamed: "playerMovement0")
        let spriteComponent = SpriteComponent(texture: playerSpriteTexture, height: playerHeight, position: CGPoint(x: 200, y: 600))
        
        spriteComponent.node.entity = self
        spriteComponent.node.physicsBody = PhysicBodyBuilder()
            //.withTexture(playerSpriteTexture, size: spriteComponent.node.size)
            .withCircle(height: playerHeight / 1.5)
            .setMass(10)
            .setLinearDamping(0)
            .setIsDynamic(true)
            .setAllowsRotation(false)
            .setAffectedByGravity(true)
            .setRestitution(0.0)
            .setPhysicsCategories(mask: PhysicsCategory.player, collision: [PhysicsCategory.obstacles], contact: [PhysicsCategory.coin, PhysicsCategory.meteor])
            .build()
        //spriteComponent.node.physicsBody = nil
        addComponent(spriteComponent)
        
        let jumpVelocity = CGVector(dx: 0, dy: 5000)
        let jumpComponent = JumpComponent(jumpVelocity: jumpVelocity, maxJumps: 2)
        addComponent(jumpComponent)
        
        let movementForceVector = CGVector(dx: 7000, dy: 0)
        let maxVelocity: CGFloat = 500
        let movementComponent = PlayerMovementComponent(movementForce: movementForceVector, maxVelocity: maxVelocity)
        addComponent(movementComponent)
        
        let movementAtlas = TextureProvider.shared.getAtlas(named: "run")
        let fastMovementAtlas = TextureProvider.shared.getAtlas(named: "fastMove")
        let animationComponent = AnimationComponent(spriteNode: spriteComponent.node, atlases: [
            AnimationNames.playerMovement.rawValue : movementAtlas,
            AnimationNames.playerFastMovement.rawValue : fastMovementAtlas
        ])
        addComponent(animationComponent)
        
        let detectionNodeHeightCoefficient: CGFloat = 1.5
        let detectionNodeRadius = playerHeight * detectionNodeHeightCoefficient
        let detectionNode = SKNode()
        let meteorDetectionComponent = MeteorDetectionComponent(detectionNode: detectionNode, height: detectionNodeRadius)
        addComponent(meteorDetectionComponent)
        
        animationComponent.playAnimation(named: AnimationNames.playerMovement.rawValue, loop: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum PlayerType {
    case origin
}
