//
//  FavoritesViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 04/07/22.
//


protocol FavoritesViewModelType {
    func getComics() -> [ComicModel]?
    func getComic(at index: Int) -> ComicModel?
}

class FavoritesViewModel: FavoritesViewModelType {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let comicManager: ComicObjectManagerType
    
    // MARK: - INITIALIZER
    
    init(comicManager: ComicObjectManagerType) {
        self.comicManager = comicManager
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func getComics() -> [ComicModel]? {
        let comicObjects = comicManager.fetchAll()
        return comicObjects?.compactMap({ object in
            makeComicModel(from: object)
        })
    }
    
    func getComic(at index: Int) -> ComicModel? {
        guard let comics = getComics() else { return nil}
        if index < comics.count  {
            return comics[index]
        }
        return nil
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func makeComicModel(from object: ComicManagedObject) -> ComicModel? {
        if let id = object.id {
            let characters = makeCharactersModel(from: object.characters?.allObjects as? [CharacterManagedObject])
            let creators = makeCreatorsModel(from: object.creators?.allObjects as? [CreatorManagedObject])
            return .init(id: id,
                         title: object.title,
                         description: object.comicDescription,
                         imagePath: object.imagePath,
                         imageExtension: object.imageExtension,
                         characters: characters,
                         creators: creators,
                         isFavorite: true)
        }
        return nil
    }
    
    private func makeCharactersModel(from characters: [CharacterManagedObject]?) -> [ComicModel.Character]? {
        guard let characters = characters else {  return nil }
        return characters.compactMap { object in
            return .init(from: object)
        }
    }
    
    private func makeCreatorsModel(from creators: [CreatorManagedObject]?) -> [ComicModel.Character]? {
        guard let creators = creators else {  return nil }
        return creators.compactMap { object in
            return .init(from: object)
        }
    }
}
