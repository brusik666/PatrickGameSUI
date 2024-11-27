//
//  PhysicsCategories.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/21/24.
//


import Foundation
import UIKit

struct PhysicsCategory {
    
    static let player: UInt32 = 0x1 << 0
    static let obstacles: UInt32 = 0x1 << 1
    static let coin: UInt32 = 0x1 << 2
    static let meteor: UInt32 = 0x1 << 3
    static let meteorSensor: UInt32 = 0x1 << 4
}
