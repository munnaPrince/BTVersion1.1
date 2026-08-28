# Btracker (iOS) - Production-ready Frontend

This workspace contains a SwiftUI production-stage restructure of the Btracker iOS app.

Main highlights:

- Registration & onboarding
- Calorie & protein target calculation
- Image-based food scan (mock analysis for now)
- Core Data persistence (programmatically-created model)
- Organized source layout and a minimal Xcode project (`Btracker.xcodeproj`)

Project layout (key files):

- `BtrackerApp.swift` — App entry, injects `AppStore` and Core Data context
- `Models.swift` — lightweight structs used by the UI
- `CoreDataStack.swift` — programmatic Core Data model and container
- `ManagedObjects.swift` — `NSManagedObject` subclasses + mapping helpers
- `DataService.swift` — Core Data CRUD wrapper
- `Storage.swift` — `AppStore` observable object backed by `DataService`
- `Views.swift`, `ImagePicker.swift`, `MacroCalculator.swift` — UI and helpers

New folder layout (production-ready):

- `Sources/App` — app entry and app-level files
- `Sources/Models` — model definitions
- `Sources/Views` — SwiftUI views
- `Sources/Services` — data & persistence (Core Data stack, data service)
- `Sources/Utils` — helpers (image picker, calculator)
- `Resources` — assets and storyboards
- `Tests` — unit tests

How to open and run

1. Open Xcode and choose Open... then select `Btracker.xcodeproj` in this folder.
2. Select a simulator (iPhone 13 / iOS 15+ recommended) and Run.

Notes & next steps

- The Core Data model is created programmatically to keep the repo portable without an `.xcdatamodeld` file. It defines `CDUserProfile` and `CDFoodEntry` entities.
- Image analysis is still a mock — when you're ready we can integrate a CoreML food recognizer or a backend inference endpoint.
- I added a minimal pbxproj that references the source files; for complex app configurations (multiple targets, app groups, push entitlements) we'll expand the project file in Xcode.
