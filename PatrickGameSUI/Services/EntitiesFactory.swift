//
//  EntitiesFactory.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/2/24.
//

import Foundation

class EntitiesFactory {
    static func createMeteorEntity(type: MeteorType, position: CGPoint) -> Meteor {
        let meteorEntity = Meteor(type: type, position: position)
        return meteorEntity
    }
    
    static func createPlayerEntity(type: PlayerType, height: CGFloat) -> Player {
        let playerEntity = Player(height: height)
        return playerEntity
    }
    
    static func createCoinEntity(height: CGFloat, position: CGPoint) -> Coin {
        let coin = Coin(height: height, position: position)
        return coin
    }
}
