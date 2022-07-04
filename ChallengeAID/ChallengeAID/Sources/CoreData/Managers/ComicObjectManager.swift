//
//  ComicManager.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import CoreData
import UIKit

public protocol ComicObjectManagerType: EntityManagerProtocol {
    func create(from comic: Comic) -> ComicManagedObject?
    func fetchAll() -> [UserComic]?
}

final class ComicObjectManager: EntityManager {
    
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
}

extension ComicObjectManager: ComicObjectManagerType {
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func create(from comic: Comic) -> ComicManagedObject? {
        let comicObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: coreDataContext)
        guard let object = comicObject as? ComicManagedObject,
              let comicId = comic.id else {
            print("Could not create entity \(entityName)")
            return nil
        }
        object.id = String(comicId)
        object.title = comic.title
        object.comicDescription = comic.description
        object.imagePath = comic.images?.first?.path
        object.imageExtension = comic.images?.first?.imageExtension
        return object
    }
    
    public func fetchAll() -> [UserComic]? {
        let fetchRequest = NSFetchRequest<UserComic>(entityName: entityName)
        do {
            let comics = try coreDataContext.fetch(fetchRequest)
            return comics
        } catch {
            print("DEU RUIM")
            return nil
        }
    }
}
