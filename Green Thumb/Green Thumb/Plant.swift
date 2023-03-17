//
//  Houseplant.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI

// Plants for ReferenceView, decoded from plants.json
struct Plant: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let wateringRequirements: String
    let growingMedium: String
}
