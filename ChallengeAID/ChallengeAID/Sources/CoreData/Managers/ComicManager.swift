//
//  ComicManager.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import CoreData

public protocol ComicManagerProtocol: EntityManagerProtocol {
    func create(_ comic: Comic)
    func fetchAll() -> [UserComic]?
}

final class ComicManager: EntityManager {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let entityName = "UserComic"
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func saveContext() {
        do {
            try coreDataContext.save()
        } catch let error {
            print("Sorry, we can't save the comic. Try again later. \n \(error)")
        }
    }
}

extension ComicManager: ComicManagerProtocol {
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func create(_ comic: Comic) {
        let comicObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: coreDataContext)
        
        guard let comic = comicObject as? UserComic else {
            print("Could not find UserComic class")
            return
        }
        
        comic.id = UUID()
        comic.title = comic.title
        comic.comicDescription = comic.description
        saveContext()
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

