//
//  Meteor.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/31/24.
//

import Foundation
import  GameplayKit

class Meteor: GKEntity {
    
    override init() {
        super.init()
        
        let spriteTexture = SKTexture(imageNamed: ImageName.Entities.meteor.rawValue)
        let spriteComponent = SpriteComponent(texture: spriteTexture, height: 100, position: .zero)
        addComponent(spriteComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
