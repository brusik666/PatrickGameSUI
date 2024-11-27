//
//  MovementComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/25/24.
//

import GameplayKit

class MovementComponent: GKComponent {
    func infiniteRotation(circleDuration: CGFloat) {
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            print("There is no SpriteComponent within current entity")
            return
        }
        let rotationAction = SKAction.rotate(byAngle: 1, duration: circleDuration)
        let foreverAction = SKAction.repeatForever(rotationAction)
        spriteNode.run(foreverAction, withKey: ActionNames.infiniteRotation.rawValue)
    }
}
