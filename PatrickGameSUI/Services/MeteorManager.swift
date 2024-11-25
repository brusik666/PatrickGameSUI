//
//   MeteorManager.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/25/24.
//

import Foundation
protocol MeteorHandler {
    func addMeteor(_ meteor: Meteor) async
    func removeMeteor(_ meteor: Meteor) async -> Bool
    func getActiveMeteors() async -> Set<Meteor>
    func getPooledMeteor(ofType type: MeteorType) async -> Meteor?
}



actor MeteorManager: MeteorHandler {
    private var activeMeteors: Set<Meteor> = []
    private var meteorPool: Set<Meteor> = []
    
    func addMeteor(_ meteor: Meteor) async {
        activeMeteors.insert(meteor)
    }
    
    //returns true if meteor is removed
    func removeMeteor(_ meteor: Meteor) async -> Bool {
        if activeMeteors.remove(meteor) != nil {
            meteorPool.insert(meteor)
            return true
        }
        return false
    }
    
    func getActiveMeteors() async -> Set<Meteor> {
        activeMeteors
    }
    
    func getPooledMeteor(ofType type: MeteorType) async -> Meteor? {
        return meteorPool.popFirst()
    }
}
