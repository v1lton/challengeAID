//
//  DetailsViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import RxSwift
import CoreGraphics

enum DetailsViewState {
    case loading
    case success
    case error(_ error: Error)
}

protocol DetailsViewModelProtocol {
    
    var viewState: BehaviorSubject<DetailsViewState> { get }
    
    func getComic() -> ComicModel
    func favoriteComic()
    func unfavoriteComic()
    func getCharacters() -> [CharacterModel]?
    func getCreators() -> [ComicModel.Character]?
    func getTableViewHeight() -> CGFloat
    func retrieveCharacters()
    func getNumberOfSections() -> Int
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let comicManager: ComicObjectManagerType
    private let charactersUseCase: CharactersUseCaseType
    private var model: DetailsModel
    private let disposeBag = DisposeBag()
    
    // MARK: - PUBLIC PROPERTIES
    
    var viewState: BehaviorSubject<DetailsViewState> = .init(value: .loading)
    
    // MARK: - INITIALIZER
    
    init(model: DetailsModel,
         comicManager: ComicObjectManagerType,
         charactersUseCase: CharactersUseCaseType) {
        self.model = model
        self.comicManager = comicManager
        self.charactersUseCase = charactersUseCase
    }
    
    // MARK: - PUBLIC METHODS
    
    func retrieveCharacters() {
        viewState.onNext(.loading)
        guard let ids = model.getCharactersIds() else {
            viewState.onNext(.success)
            return
        }
        charactersUseCase.execute(with: ids)
            .subscribeOnMainDisposed(by: disposeBag) { [weak self] result in
                self?.handleRetrieveCharacters(result)
            }
    }
    
    func getComic() -> ComicModel {
        return model.comic
    }
    
    func getCharacters() -> [CharacterModel]? {
        return model.characters
    }
    
    func getCreators() -> [ComicModel.Character]? {
        return model.comic.creators
    }
    
    func getTableViewHeight() -> CGFloat {
        let charactersCount: Int = model.comic.characters?.count ?? 0
        let creatorsCount: Int = model.comic.creators?.count ?? 0
        let charactersCellHeigt = 182
        let creatorsCellHeight = 50
        let sectionTitlesHeight = 100
        let totalHeight = (charactersCount * charactersCellHeigt) + (creatorsCount * creatorsCellHeight) + sectionTitlesHeight
        return CGFloat(totalHeight)
    }
    
    func favoriteComic() {
        comicManager.create(model.comic)
    }
    
    func unfavoriteComic() {
        comicManager.delete(model.comic.id)
    }
    
    func getNumberOfSections() -> Int {
        var numberOfSections = 0
        if let characters = model.characters,
           !characters.isEmpty {
            numberOfSections += 1
        }
        if let creators =  model.comic.creators,
           !creators.isEmpty {
            numberOfSections += 1
        }
        return numberOfSections
    }
    
    // MARK: - HANDLERS
    
    private func handleRetrieveCharacters(_ response: Result<[CharacterModel], Error>){
        switch response {
        case .success(let characters):
            handleSuccess(characters)
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func handleSuccess(_ characters: [CharacterModel]) {
        model.characters = characters
        viewState.onNext(.success)
    }
    
    private func handleError(_ error: Error) {
        model.characters = nil
        viewState.onNext(.error(error))
    }
}
