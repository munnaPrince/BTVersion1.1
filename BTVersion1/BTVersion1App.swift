//
//  BTVersion1App.swift
//  BTVersion1
//
//  Created by Munnaf Koilakuntla on 28/08/26.
//

import SwiftUI
import CoreData

@main
struct BTVersion1App: App {
    @StateObject private var store = AppStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
                        
        }
    }
}
