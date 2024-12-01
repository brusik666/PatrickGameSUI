//
//  SKSpriteNode.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/29/24.
//
import SpriteKit

extension SKSpriteNode {
    func blinkAnimation() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let blinkSequence = SKAction.sequence([fadeOut, fadeIn])
        self.run(blinkSequence, withKey: "blinkAnimation")
    }
}
