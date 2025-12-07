//
//  Flashy_CardsApp.swift
//  Flashy Cards
//
//  Created by Joshua Chapman on 12/6/25.
//

import SwiftUI
import CoreData

@main
struct Flashy_CardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
