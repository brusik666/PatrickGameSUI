//
//  PlayerData.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/31/24.
//

import Foundation

class PlayerData {
    
    private(set) var collectedCoins: Int {
        didSet {
            UserDefaults.standard.set(collectedCoins, forKey: UserDefaultsKeys.playerCoins.rawValue)
            coinsUpdated?(collectedCoins)
        }
    }
    private(set) var powerUps: [PowerUpType]
    private(set) var lives: Int
    
    var coinsUpdated: ((Int) -> Void)?
    
    init() {
        self.lives = 3
        self.powerUps = []
        self.collectedCoins = UserDefaults.standard.integer(forKey: UserDefaultsKeys.playerCoins.rawValue)
    }
    
    func collectCoin() {
        collectedCoins += 1
    }
    
    func collectPowerUp(_ powerUp: PowerUpType) {
        powerUps.append(powerUp)
    }
    
    func gainLife() {
        lives += 1
    }
    
    func loseLife() {
        lives = max(lives - 1, 0)
    }
}

enum PowerUpType: String {
    case speedBoost
    case invincibility
    case doublePoints
}

enum UserDefaultsKeys: String {
    case playerCoins
}
