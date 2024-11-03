//
//  JumpComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/23/24.
//

import GameplayKit

class JumpComponent: GKComponent {
    
    private var entityNode: SKNode?
    private var jumpVelocity: CGVector
    private var superJumpVelocity: CGVector {
        CGVector(dx: 0, dy: jumpVelocity.dy * 1.5)
    }
    private var isGrounded = true
    private var maxJumps: Int
    private var jumpCount: Int
    
    init(jumpVelocity: CGVector, maxJumps: Int = 1) {
        self.jumpVelocity = jumpVelocity
        self.maxJumps = maxJumps
        self.jumpCount = 0
        super.init()
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        if let node = entity?.component(ofType: SpriteComponent.self)?.node {
            
            self.entityNode = node
        }
    }
    
    func jump(isSuperJump: Bool) {
        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        print("sobralsya prigat")
        let velocity = isSuperJump ? superJumpVelocity : jumpVelocity
        if isGrounded || jumpCount < maxJumps {
            
            
            physicsBody.applyImpulse(velocity)
            print("prignul")
            isGrounded = false
            jumpCount += 1
        }
    }
    
    func landed() {
        isGrounded = true
        jumpCount = 0
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
