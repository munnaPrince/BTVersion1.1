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
    @AppStorage("appTheme") private var appTheme: AppTheme = .system

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .preferredColorScheme(appTheme.colorScheme)
                .environmentObject(store)
                .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
        }
    }
}
