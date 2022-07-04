//
//  ComicManager.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import CoreData

public protocol ComicObjectManagerType: EntityManagerProtocol {
    func create(_ comic: ComicModel?)
    func fetchAll() -> [ComicManagedObject]?
    func isComicFavorite(_ id: String?) -> Bool
    func delete(_ id: String?)
}

final class ComicObjectManager: EntityManager, ComicObjectManagerType {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let entityName = "ComicManagedObject"
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func saveContext() {
        do {
            try coreDataContext.save()
        } catch let error {
            print("Sorry, we can't save the comic. Try again later. \n \(error)")
        }
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func create(_ comic: ComicModel?) {
        let comicObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: coreDataContext)
        guard let object = comicObject as? ComicManagedObject else {
            print("Could not create entity \(entityName)")
            return
        }
        object.id = comic?.id
        object.title = comic?.title
        object.comicDescription = comic?.description
        object.imagePath = comic?.imagePath
        object.imageExtension = comic?.imageExtension
        saveContext()
    }
    
    public func isComicFavorite(_ id: String?) -> Bool {
        guard let comicsSaved = fetchAll() else {
            return false
        }
        for comic in comicsSaved where comic.id == id {
            return true
        }
        return false
    }
    
    public func delete(_ id: String?) {
        guard let id = id else { return }
        let fetchRequest = NSFetchRequest<ComicManagedObject>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let comic = try coreDataContext.fetch(fetchRequest).first
            if let comic = comic {
                coreDataContext.delete(comic)
            } else {
                print("Comic \(id) was not found")
            }
        }
        catch {
            print("Error deleting comic \(id)")
        }
        saveContext()
    }
    
    public func fetchAll() -> [ComicManagedObject]? {
        let fetchRequest = NSFetchRequest<ComicManagedObject>(entityName: entityName)
        do {
            let comics = try coreDataContext.fetch(fetchRequest)
            return comics
        } catch {
            return nil
        }
    }
}

