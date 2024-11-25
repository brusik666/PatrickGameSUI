//
//  EntityStorage.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/25/24.
//

import GameplayKit

protocol EntityContainer {
    func add(entity: GKEntity) async
    func markForRemoval(entity: GKEntity) async
    func remove(entity: GKEntity) async
    func getEntitiesToRemove() async -> Set<GKEntity>
    func contains(entity: GKEntity) async -> Bool
}



actor EntityStorage: EntityContainer {
    private var entities = Set<GKEntity>()
    private var entitiesToRemove = Set<GKEntity>()
    
    func add(entity: GKEntity) async {
        entities.insert(entity)
    }
    
    func markForRemoval(entity: GKEntity) async {
        entitiesToRemove.insert(entity)
    }
    
    func remove(entity: GKEntity) async {
        entities.remove(entity)
    }
    
    func getEntitiesToRemove() async -> Set<GKEntity> {
        let toRemove = entitiesToRemove
        entitiesToRemove.removeAll()
        return toRemove
    }
    
    func contains(entity: GKEntity) async -> Bool {
        entities.contains(entity)
    }
}
