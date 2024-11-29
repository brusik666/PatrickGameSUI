//
//  PlayerMovementComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/22/24.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerMovementComponent: GKComponent {
    
    enum MovementState {
        case normal, speedUp, slowDown
    }
    
    private var entityNode: SKSpriteNode?
    private var movementForce: CGVector
    private var maxVelocity: CGFloat
    private var speedMultiplier: CGFloat
    private var movementState: MovementState
    
    init(movementForce: CGVector, maxVelocity: CGFloat) {
        self.movementForce = movementForce
        self.maxVelocity = maxVelocity
        self.speedMultiplier = 1.0
        self.movementState = .normal
        super.init()
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()

        if let node = entity?.component(ofType: SpriteComponent.self)?.node {
            self.entityNode = node
            self.entityNode?.physicsBody?.linearDamping = 0.1
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //move()
    }
    
    func stopPlayer() {
        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        
        physicsBody.velocity = CGVector(dx: 0, dy: 0)
        physicsBody.angularVelocity = 0
    }
    
    
    func increaseSpeed() {
        guard movementState == .normal else { return }
        movementState = .speedUp
        guard let sprite = entityNode,
              let physicsBody = sprite.physicsBody else { return }
        physicsBody.applyImpulse(CGVector(dx: 10000, dy: 0))
        if let animationComponent = entity?.component(ofType: AnimationComponent.self) {
            animationComponent.playDashTrailEffect()
        }
         Task {
             await resetSpeedAfterDelay()
         }
    }
    
    
    func slowDown() {
        guard movementState == .normal else { return }
        movementState = .slowDown
        speedMultiplier = 0.3
        //print("SLOW DOWN")
        Task {
            await resetSpeedAfterDelay()
        }
    }
    
    private func resetSpeedAfterDelay() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        resetSpeed()
    }
    
    
    
    
    private func resetSpeed() {
        speedMultiplier = 1.0
        movementState = .normal
    }
    
    private func move() {
        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        guard movementState == .normal || movementState == .slowDown else { return }
            
        let scaledForce = CGVector(dx: movementForce.dx * speedMultiplier, dy: movementForce.dy)
        if physicsBody.velocity.dx < maxVelocity * speedMultiplier {
            physicsBody.applyForce(scaledForce)
        }
        
        if physicsBody.velocity.dx > maxVelocity * speedMultiplier {
            physicsBody.velocity.dx = maxVelocity * speedMultiplier
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
