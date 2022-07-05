//
//  ComicsViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import RxSwift
import CoreData

class ComicsViewModel: ComicsViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let comicManager: ComicObjectManagerType
    private let comicsUseCase: ComicsUseCaseType
    private var comics: [ComicModel]?
    private let disposeBag = DisposeBag()
    
    // MARK: - PUBLIC PROPERTIES
    
    var viewState: BehaviorSubject<ComicsViewState> = .init(value: .loading)
    var isPaginating: Bool = false
    var filterModel: FilterSearchModel?
    
    // MARK: - INITIALIZERS
    
    init(comicManager: ComicObjectManagerType, comicsUseCase: ComicsUseCaseType) {
        self.comicManager = comicManager
        self.comicsUseCase = comicsUseCase
    }
    
    // MARK: - PUBLIC METHODS
    
    func getComics() -> [ComicModel]? {
        if let filterModel = filterModel {
            return getFilteredComics(filterModel)
        }
        return comics
    }
    
    func getComic(at index: Int) -> ComicModel? {
        guard var comic = comics?[index] else { return nil }
        comic.isFavorite = comicManager.isComicFavorite(comic.id)
        return comic
    }
    
    func favoriteComic(from index: Int) {
        guard let comicObject = comics?[index] else {return}
        comicManager.create(comicObject)
    }
    
    func retrieveComics(pagination: Bool) {
        if pagination {
            isPaginating = true
        }
        let offset = !pagination ? 0 : (comics?.count ?? 0 + 1)
        comicsUseCase.execute(with: .init(offset: offset))
            .subscribeOnMainDisposed(by: disposeBag) { [weak self] result in
                self?.isPaginating = false
                self?.handleRetrieveComics(result)
            }
    }
    
    // MARK: - HANDLERS
    
    private func handleRetrieveComics(_ response: Result<[ComicModel]?, Error>) {
        switch response {
        case .success(let comics):
            handleSuccess(comics)
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func handleSuccess(_ comics: [ComicModel]?) {
        guard let comics = comics else { return handleEmptyComics() }
        if self.comics == nil {
            self.comics = comics
        } else {
            self.comics?.append(contentsOf: comics)
        }
        viewState.onNext(.content(comics))
    }
    
    private func handleEmptyComics() { }
    
    private func handleError(_ error: Error) {
        print(error)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func getFilteredComics(_ filterModel: FilterSearchModel) -> [ComicModel]? {
        return comics?.filter({ comic in
            if let comicTitle = comic.title?.lowercased(),
               comicTitle.contains(filterModel.text.lowercased()) {
                return true
            }
            return false
        })
    }
}
