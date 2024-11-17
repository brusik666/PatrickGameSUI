//
//  GameView.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/13/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    var body: some View {
        GeometryReader { geometry in
            
            SpriteView(scene: {
                let playerData = PlayerData()
                let gameScene = GameScene(size: geometry.size, playerData: playerData)
                gameScene.view?.showsPhysics = true
                gameScene.view?.showsFPS = true
                gameScene.scaleMode = .aspectFill  // Ensure the scene resizes to fit the screen
                return gameScene
            }())
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
