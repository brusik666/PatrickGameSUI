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
    
    override init() {
        super.init()
        
        let playerSpriteTexture = SKTexture(imageNamed: "player")
        let spriteComponent = SpriteComponent(texture: playerSpriteTexture, height: 150, position: CGPoint(x: 100, y: 600))
        spriteComponent.node.entity = self
        addComponent(spriteComponent)
        
        let jumpVelocity = CGVector(dx: 0, dy: 5000)
        let jumpComponent = JumpComponent(jumpVelocity: jumpVelocity, maxJumps: 1)
        addComponent(jumpComponent)
        
        let movementForceVector = CGVector(dx: 5000, dy: 0)
        let maxVelocity: CGFloat = 300
        let moveMentComponent = PlayerMovementComponent(movementForce: movementForceVector, maxVelocity: maxVelocity)
        addComponent(moveMentComponent)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
