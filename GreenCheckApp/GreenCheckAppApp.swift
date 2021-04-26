//
//  GreenCheckAppApp.swift
//  GreenCheckApp
//
//  Created by Florian Bauer on 26.04.21.
//

import SwiftUI

@main
struct GreenCheckAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
