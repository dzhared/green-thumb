//
//  Green_ThumbApp.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI

@main
struct Green_ThumbApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
