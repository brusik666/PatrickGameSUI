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
        spriteComponent.node.entity = self
        spriteComponent.node.physicsBody = PhysicBodyBuilder()
            .configurePhysicsBody(isDynamic: true, affectedByGravity: true ,isTextured: true, spriteNode: spriteComponent.node)
            .setPhysicsCategories(mask: PhysicsCategory.coin, collision: [], contact: [PhysicsCategory.player])
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
