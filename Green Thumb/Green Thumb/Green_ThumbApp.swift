//
//  Green_ThumbApp.swift
//  Green Thumb
//
//  Created by Jared on 3/8/23.
//

import SwiftUI

@main
struct Green_ThumbApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
