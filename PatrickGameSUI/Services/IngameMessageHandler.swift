//
//  IngameMessageHandler.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/25/24.
import SpriteKit

struct SceneMessageLabelHandler {
    static func showMessage(label: SKLabelNode, text: String, presentationTime: CGFloat) {
        
        label.text = text
        label.isHidden = false

        let delay = DispatchTime.now() + Double(presentationTime)
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            label.isHidden = true
        }
    }
}

