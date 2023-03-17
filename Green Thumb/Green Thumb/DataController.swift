//
//  DataController.swift
//  Green Thumb
//
//  Created by Jared on 3/17/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    // Define which data model to use
    let container = NSPersistentContainer(name: "GreenThumb")
    
    // Initialize by loading data
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
