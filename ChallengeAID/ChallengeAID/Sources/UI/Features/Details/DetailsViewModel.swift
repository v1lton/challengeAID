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
    
    func favoriteComic() {
        comicManager.create(model.comic)
    }
    
    func unfavoriteComic() {
        comicManager.delete(model.comic.id)
    }
}
