//
//  SpriteComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture, height: CGFloat, position: CGPoint = .zero) {
        node = SpriteBuilder<SKSpriteNode>()
            .setPosition(position)
            .setTexture(texture)
            .setSizeByHeight(height)
            .setZPosition(5)
            .setPhysicsBody(isDynamic: true, affectedByGravity: true ,isTexured: true)
            .setPhysicsCategories(mask: PhysicsCategory.player, collision: [PhysicsCategory.obstacles], contact: [])
            .build()
        print(node.physicsBody)
        node.physicsBody?.allowsRotation = false
        //node.run(.repeatForever(.move(by: CGVector(dx: 20, dy: 0), duration: 1)))
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
