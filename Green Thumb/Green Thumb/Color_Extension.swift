//
//  Color_Extension.swift
//  Green Thumb
//
//  Created by Jared on 3/9/23.
//

import Foundation
import SwiftUI

extension Color {
    public static var darkGreen: Color {
        // Hex:            #3F5735
        // Contrast ratio: 8:1 (white text)
        return Color(red: 0.247, green: 0.341, blue: 0.208)
    }
    
    public static var lightGreen: Color {
        // Hex: #8FBF7A
        // Contrast ratio: 9.9:1 (black text)
        return Color(red: 0.561, green: 0.749, blue: 0.478)
    }
}
