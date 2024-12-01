//
//  TImeBarController.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/29/24.
//
import Combine

class TimeBarController {
    private let timeBar: TimeRemainBar
    private var cancellables = Set<AnyCancellable>()

    init(timeBar: TimeRemainBar) {
        self.timeBar = timeBar

        // Subscribe to meteor evasion events
        MeteorEventBus.shared.meteorEvasionPublisher
            .sink { [weak self] _ in
                self?.handleMeteorEvasion()
            }
            .store(in: &cancellables)
    }

    private func handleMeteorEvasion() {
        timeBar.startTimer(over: 3)
    }
}
