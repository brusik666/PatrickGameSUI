//
//  GamePointsManager.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/13/24.
//

protocol PointsCounter {
    func addPoints(count: Int)
    func setMultiplier(value: Int)
}

import Foundation

class GamePointsCounter: PointsCounter {
    
    private var multiplier: Int = 1
    private var currentPoints: Int = 0
    
    func addPoints(count: Int) {
        currentPoints += multiplier * count
    }
    
    func setMultiplier(value: Int) {
        multiplier = value
    }
    
    
}
