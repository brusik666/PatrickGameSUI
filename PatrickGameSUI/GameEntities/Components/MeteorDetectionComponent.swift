//
//  MeteorDetectionComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/19/24.
//

import GameplayKit
import SpriteKit
import Combine

import GameplayKit
import Combine

class MeteorDetectionComponent: GKComponent {
    private var detectionNode: SKNode
    private var meteorsInSensor: [Meteor: TimeInterval] = [:]
    private let sensorTimeout: TimeInterval = 0.25

    init(detectionNode: SKNode, height: CGFloat) {
        self.detectionNode = detectionNode
        super.init()
        setupPhysicsBody(height: height)
    }

    override func didAddToEntity() {
        guard let playerNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            print("Error: SpriteComponent or its node is missing.")
            return
        }
        detectionNode.position = .zero
        playerNode.addChild(detectionNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        checkEvadedMeteors()
        detectionNode.position = .zero
    }

    private func setupPhysicsBody(height: CGFloat) {
        let body = PhysicBodyBuilder()
            .withCircle(height: height)
            .setIsDynamic(true)
            .setPhysicsCategories(mask: PhysicsCategory.meteorSensor, collision: [], contact: [PhysicsCategory.meteor])
            .setAffectedByGravity(false)
            .build()
        detectionNode.physicsBody = body
    }

    private func checkEvadedMeteors() {
        let currentTime = Date().timeIntervalSince1970
        var meteorsToRemove: [Meteor] = []

        for (meteor, entryTime) in meteorsInSensor {
            if currentTime - entryTime > sensorTimeout {
                publishMeteorEvaded(meteor)
                meteorsToRemove.append(meteor)
            }
        }

        // Remove evaded meteors
        meteorsToRemove.forEach { meteorsInSensor.removeValue(forKey: $0) }
    }

    func meteorDidEnterSensor(_ meteor: Meteor) {
        if meteorsInSensor[meteor] == nil {
            meteorsInSensor[meteor] = Date().timeIntervalSince1970
        }
    }

    func meteorDidExitSensor(_ meteor: Meteor) {
        meteorsInSensor.removeValue(forKey: meteor)
    }

    func meteorDidHitPlayer(_ meteor: Meteor) {
        // Simply remove the meteor from the sensor list when it hits the player
        meteorsInSensor.removeValue(forKey: meteor)
    }

    private func publishMeteorEvaded(_ meteor: Meteor) {
        MeteorEventBus.shared.meteorEvasionPublisher.send(meteor)
        print("Meteor evaded: \(meteor)")
    }
}
