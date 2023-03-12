//
//  Houseplant.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI

// Plants for database, decoded from plants.json
struct Plant: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let wateringRequirements: String
    let growingMedium: String
}

// User's own plants, identifiable by UUID
struct UserPlant: Codable, Identifiable {
    var id = UUID()
    let name: String
    let nickName: String
    let description: String
}

// Class to store UserPlant in UserDefaults
class UserPlants: ObservableObject {
    init() {
        // See if savedPlants exists
        if let savedPlants = UserDefaults.standard.data(forKey: "Plants") {
            // Attempt to decode list
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            if let decodedItems = try? decoder.decode([UserPlant].self, from: savedPlants) {
                // Assign decodedItems to plants and return
                plants = decodedItems
                return
            }
        }
        // Create empty list of plants if none exists
        plants = []
    }
    
    @Published var plants = [UserPlant]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(plants) {
                UserDefaults.standard.set(encoded, forKey: "Plants")
            }
        }
    }
}
