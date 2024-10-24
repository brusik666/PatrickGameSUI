//
//  PhysicsCategories.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/21/24.
//


import Foundation
import UIKit

struct PhysicsCategory {
    
    static let player: UInt32 = 0x1 << 1
    static let obstacles: UInt32 = 0x2 << 1
}
