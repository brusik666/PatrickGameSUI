//
//  ImageNames.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/3/24.
//

import Foundation

enum ImageName {
    
    enum Buttons: String {
        case playButton, settingsButton, shopButton, dailyBonusButton
    }
    
    enum Backgrounds: String {
        case background
    }
    
    enum Entities: String {
        case player, coin, smallMeteor, mediumMeteor, bigMeteor
    }
    
    enum AtlasesNames {
        
    }
}

enum AnimationNames: String {
    case playerMovement, playerFastMovement
}

enum ActionNames: String {
    case infiniteRotation
}

enum NodeName: String {
    case meteorRoomNode
}
