//
//  DataService.swift
//  BTVersion1
//
//  Created by Munnaf Koilakuntla on 28/08/26.
//

import Foundation
import CoreData

final class DataService {
    static let shared = DataService()
    private let container: NSPersistentContainer

    private init(container: NSPersistentContainer = CoreDataStack.shared.container) {
        self.container = container
    }

    var context: NSManagedObjectContext { container.viewContext }

    // MARK: - Profile
    func fetchProfile() -> UserProfile? {
        let req = NSFetchRequest<CDUserProfile>(entityName: "CDUserProfile")
        req.fetchLimit = 1
        if let res = try? context.fetch(req), let cd = res.first {
            return cd.toModel()
        }
        return nil
    }

    func saveProfile(_ p: UserProfile) throws {
        // delete existing then create one
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUserProfile")
        let del = NSBatchDeleteRequest(fetchRequest: req)
        _ = try context.execute(del)

        _ = CDUserProfile.create(from: p, in: context)
        try context.save()
    }

    // MARK: - Entries
    func fetchEntries() -> [FoodEntry] {
        let req = NSFetchRequest<CDFoodEntry>(entityName: "CDFoodEntry")
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let res = (try? context.fetch(req)) ?? []
        return res.map { $0.toModel() }
    }

    func addEntry(_ e: FoodEntry) throws {
        _ = CDFoodEntry.create(from: e, in: context)
        try context.save()
    }

    func deleteEntry(id: UUID) throws {
        let req = NSFetchRequest<CDFoodEntry>(entityName: "CDFoodEntry")
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let res = try? context.fetch(req) {
            for obj in res { context.delete(obj) }
            try context.save()
        }
    }
}
