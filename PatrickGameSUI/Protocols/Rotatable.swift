//
//  Rotatable.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/28/24.
//

import SpriteKit

protocol Rotatable where Self: SKSpriteNode {
    func infiniteRotation(lapTime: TimeInterval)
}

extension Rotatable {
    func infiniteRotation(lapTime: TimeInterval) {
        let angle: CGFloat = 1
        let rotateAction = SKAction.rotate(byAngle: angle, duration: lapTime)
        let infiniteRotationAction = SKAction.repeatForever(rotateAction)
        self.run(infiniteRotationAction)
    }
}


