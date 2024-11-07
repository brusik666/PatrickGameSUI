//
//  Coin.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/31/24.
//

import Foundation
import GameplayKit

class Coin: GKEntity {
    
    override init() {
        super.init()
        
        let spriteTexture = SKTexture(imageNamed: ImageName.Entities.coin.rawValue)
        let spriteComponent = SpriteComponent(texture: spriteTexture, height: 50, position: CGPoint(x: 350, y: 600))
        let spriteNode = spriteComponent.node
        spriteNode.entity = self
        spriteNode.physicsBody = PhysicBodyBuilder()
            .withTexture(spriteTexture, size: spriteNode.size)
            .setMass(0.01)
            .setAffectedByGravity(true)
            .setIsDynamic(true)
            .setPhysicsCategories(mask: PhysicsCategory.coin, collision: [PhysicsCategory.obstacles], contact: [PhysicsCategory.player])
            .build()
        addComponent(spriteComponent)
        
        let collectableComponent = CollectableComponent(type: .coin)
        addComponent(collectableComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Coin entity deinitialized")
    }
}
