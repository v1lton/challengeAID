//
//  DetailsViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

protocol DetailsViewModelProtocol {
    func getComic() -> ComicModel
    func favoriteComic()
    func unfavoriteComic()
    func getCharacters() -> [ComicModel.CharacterModel]?
    func getCreators() -> [ComicModel.CharacterModel]?
    func getTableViewCount() -> Int
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let comicManager: ComicObjectManagerType
    private let model: DetailsModel
    
    // MARK: - INITIALIZER
    
    init(model: DetailsModel, comicManager: ComicObjectManagerType) {
        self.model = model
        self.comicManager = comicManager
    }
    
    // MARK: - PUBLIC METHODS
    
    func getComic() -> ComicModel {
        return model.comic
    }
    
    func getCharacters() -> [ComicModel.CharacterModel]? {
        return model.comic.characters
    }
    
    func getCreators() -> [ComicModel.CharacterModel]? {
        return model.comic.creators
    }
    
    func getTableViewCount() -> Int {
        let charactersCount: Int = model.comic.characters?.count ?? 0
        let creatorsCount: Int = model.comic.creators?.count ?? 0
        return charactersCount + creatorsCount
    }
    
    func favoriteComic() {
        comicManager.create(model.comic)
    }
    
    func unfavoriteComic() {
        comicManager.delete(model.comic.id)
    }
}
