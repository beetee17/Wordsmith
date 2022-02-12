//
//  Persistence.swift
//  Wordsmith
//
//  Created by Brandon Thio on 12/2/22.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let _ = Game(context: viewContext, currStreak: 10, prevBest: 22, numPlayed: 40, numLetters: 5, numGuesses: ["1" : 0, "2" : 2, "3" : 7, "4" : 10, "5" : 13, "6" : 8], guessHistory: ["rates" : 20, "great" : 10, "arise" : 5, "champ" : 3, "wordy" : 1])
        
        let _ = Game(context: viewContext, currStreak: 10, prevBest: 22, numPlayed: 40, numLetters: 6, numGuesses: ["1" : 0, "2" : 2, "3" : 7, "4" : 10, "5" : 13, "6" : 8], guessHistory: ["greats" : 20, "raised" : 10, "arouse" : 5, "champs" : 3, "bottom" : 1])
        
        let _ = Game(context: viewContext, currStreak: 10, prevBest: 22, numPlayed: 40, numLetters: 7, numGuesses: ["1" : 0, "2" : 2, "3" : 7, "4" : 10, "5" : 13, "6" : 8], guessHistory: ["acquire" : 20, "charter" : 10, "climate" : 5, "imagine" : 3, "liberty" : 1])
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    static func initCoreData() {
        let _ = Game(context: moc, numLetters: 5)
        let _ = Game(context: moc, numLetters: 6)
        let _ = Game(context: moc, numLetters: 7)
        
        do {
            try moc.save()
            print("SUCCESSFULLY ADDED GAME MODES")
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Wordsmith")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension NSManagedObjectContext {
    func safeFetch<T>(_ request: NSFetchRequest<T>, _ predicate: NSPredicate) -> [T] where T : NSFetchRequestResult {
        do {
            request.predicate = predicate
            print("FETCHING")
            return try self.fetch(request)
        } catch let error {
            ErrorViewModel.shared.showBanner(title: "Could not fetch \(T.self) items", message: error.localizedDescription)
            print("Could not fetch the given request: \(request) \n\(error.localizedDescription)")
            return []
        }
    }
    
    func safeSave() {
        do {
            try self.save()
        } catch let error {
            ErrorViewModel.shared.showBanner(title: "Could not save moc", message: error.localizedDescription)
            print("Could not save moc: \n\(error.localizedDescription)")
        }
    }
}
