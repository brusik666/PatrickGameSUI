//
//  IngameMessageHandler.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/25/24.
import SpriteKit

struct SceneMessageLabelHandler {
    static func showMessage(label: SKLabelNode,text: String, presentationTime: CGFloat) async {
        await MainActor.run {
            label.text = text
            label.isHidden = false
        }
        
        let nanoseconds = UInt64(presentationTime * 1_000_000_000)
        
        do {
            try await Task.sleep(nanoseconds: nanoseconds)
        } catch {
            print("Task was cancelled: \(error)")
        }
        await MainActor.run {
            label.isHidden = true
        }
    }
}
