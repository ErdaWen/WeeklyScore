//
//  WeeklyScoreApp.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI

@main
struct WeeklyScoreApp: App {
    @AppStorage("nightMode") private var nightMode = true
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(Initializer())
                .environmentObject(PropertiesModel())
                .preferredColorScheme(nightMode ? nil : .light)
        }
    }
}
