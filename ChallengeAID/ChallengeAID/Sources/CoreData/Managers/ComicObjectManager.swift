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
    
    private let comicEntityName = "ComicManagedObject"
    private let characterEntityName = "CharacterManagedObject"
    private let creatorEntityName = "CreatorManagedObject"
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func saveContext() {
        do {
            try coreDataContext.save()
        } catch let error {
            print("Sorry, we can't save the comic. Try again later. \n \(error)")
        }
    }
    
    private func makeCharactersSet(from characters: [ComicModel.Character]?, for comic: ComicManagedObject) {
        guard let characters = characters else { return }
        for character in characters {
            let characterObject = NSEntityDescription.insertNewObject(forEntityName: characterEntityName, into: coreDataContext)
            if let object = characterObject as? CharacterManagedObject {
                object.comic = comic
                object.resourceURI = character.resourceURI
                object.name = character.name
                object.role = character.role
            } else {
                print("Could not create entity CharacterManagedObject")
            }
        }
    }
    
    private func makeCreatorsSet(from creators: [ComicModel.Character]?, for comic: ComicManagedObject) {
        guard let creators = creators else { return }
        for creator in creators {
            let creatorObject = NSEntityDescription.insertNewObject(forEntityName: creatorEntityName, into: coreDataContext)
            if let object = creatorObject as? CreatorManagedObject {
                object.comic = comic
                object.resourceURI = creator.resourceURI
                object.name = creator.name
                object.role = creator.role
            } else {
                print("Could not create entity CreatorManagedObject")
            }
        }
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func create(_ comic: ComicModel?) {
        let comicObject = NSEntityDescription.insertNewObject(forEntityName: comicEntityName, into: coreDataContext)
        guard let object = comicObject as? ComicManagedObject else {
            print("Could not create entity \(comicEntityName)")
            return
        }
        object.id = comic?.id
        object.title = comic?.title
        object.comicDescription = comic?.description
        object.imagePath = comic?.imagePath
        object.imageExtension = comic?.imageExtension
        makeCharactersSet(from: comic?.characters, for: object)
        makeCreatorsSet(from: comic?.creators, for: object)
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
        let fetchRequest = NSFetchRequest<ComicManagedObject>(entityName: comicEntityName)
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
        let fetchRequest = NSFetchRequest<ComicManagedObject>(entityName: comicEntityName)
        do {
            let comics = try coreDataContext.fetch(fetchRequest)
            return comics
        } catch {
            return nil
        }
    }
}

