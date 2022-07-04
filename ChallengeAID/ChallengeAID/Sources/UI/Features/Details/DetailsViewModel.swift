//
//  DetailsViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

protocol DetailsViewModelProtocol {
    func getComic() -> ComicManagedObject
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    let model: DetailsModel
    
    // MARK: - INITIALIZER
    
    init(model: DetailsModel) {
        self.model = model
    }
    
    // MARK: - PUBLIC METHODS
    
    func getComic() -> ComicManagedObject {
        return model.comic
    }
}
