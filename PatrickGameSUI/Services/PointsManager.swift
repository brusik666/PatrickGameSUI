//
//  PointsManager.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/29/24.
//

import SpriteKit
import Combine

protocol PointsManager {
    func updatePlayerProgress(playerXPosition: CGFloat)
    func resetMultiplier()
    func setMultiplier(value: Int)
    var pointsUpdated: ((Int) -> Void)? { get set }
}

class GamePointsManager: PointsManager {
    
    private var lastCheckpointX: CGFloat = 0
    private let screenWidthSegment: CGFloat
    private var currentMultiplier: Int = 1
    private(set) var currentPoints: Int = 0 {
        didSet {
            pointsUpdated?(currentPoints)
        }
    }
    
    var pointsUpdated: ((Int) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()

    init(screenWidth: CGFloat) {
        self.screenWidthSegment = screenWidth / 5
        MeteorEventBus.shared.meteorEvasionPublisher
            .sink { [weak self] meteor in
                self?.handleMeteorEvasion()
            }
            .store(in: &cancellables)
    }
    
    func updatePlayerProgress(playerXPosition: CGFloat) {
        if playerXPosition > lastCheckpointX + screenWidthSegment {
            lastCheckpointX += screenWidthSegment
            awardPoints(points: 10)
        }
    }

    func awardPoints(points: Int) {
        currentPoints += currentMultiplier * points
    }

    func setMultiplier(value: Int) {
        currentMultiplier = value
    }

    func resetMultiplier() {
        currentMultiplier = 1
    }
    
    private func handleMeteorEvasion() {
        
    }
}
