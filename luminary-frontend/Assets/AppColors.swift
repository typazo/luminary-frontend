//
//  AppColors.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 12/4/25.
//
import SwiftUI

// Hex Color Initializer (Required to use hex codes)
extension Color {
    init(hex: UInt) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

//colors from the pallette kaitlyn sent
extension Color {
    
    // Primary/Dark Colors
    static let persianIndigo = Color(hex: 0x200974)
    static let purpleMonster = Color(hex: 0x38258E)
    static let warmPurple = Color(hex: 0x842F8A)
    static let mediumOrchid = Color(hex: 0xAA55B0)
    
    // Light/Background Colors
    static let veryLightPurple = Color(hex: 0xF8CDFB)
    static let amour = Color(hex: 0xFDE7FF)
    static let barleyWhite = Color(hex: 0xFFF4CC)
    
    // Alias for specific UI element
    static let textFieldBackground = Color.veryLightPurple // Using the name for easy UI reference
}
