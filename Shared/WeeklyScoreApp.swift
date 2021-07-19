//
//  WeeklyScoreApp.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI

@main
struct WeeklyScoreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
