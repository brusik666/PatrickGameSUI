//
//  MeteorEventBus.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/29/24.
//

import Combine

class MeteorEventBus {
    static let shared = MeteorEventBus()

    private init() {} // Singleton

    let meteorEvasionPublisher = PassthroughSubject<Meteor, Never>()
}
