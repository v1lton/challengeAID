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
    
    private var model: [ComicManagedObject]?
    private let disposeBag = DisposeBag()
    
    // MARK: - PUBLIC PROPERTIES
    
    var viewState: BehaviorSubject<ComicsViewState> = .init(value: .loading)
    var isPaginating: Bool = false
    
    // MARK: - INITIALIZERS
    
    init(comicManager: ComicObjectManagerType, comicsUseCase: ComicsUseCaseType) {
        self.comicManager = comicManager
        self.comicsUseCase = comicsUseCase
    }
    
    // MARK: - PUBLIC METHODS
    
    func getComics() -> [ComicManagedObject]? {
        return model
    }
    
    func saveUserComic(from index: Int) { }
    
    func retrieveComics(pagination: Bool) {
        if pagination {
            isPaginating = true
        }
        let offset = !pagination ? 0 : (model?.count ?? 0 + 1)
        comicsUseCase.execute(with: .init(offset: offset))
            .subscribeOnMainDisposed(by: disposeBag) { [weak self] result in
                self?.isPaginating = false
                self?.handleRetrieveComics(result)
            }
    }
    
    // MARK: - HANDLERS
    
    private func handleRetrieveComics(_ response: Result<[ComicManagedObject]?, Error>) {
        switch response {
        case .success(let comics):
            handleSuccess(comics)
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func handleSuccess(_ comics: [ComicManagedObject]?) {
        guard let comics =  comics else { return handleEmptyComics() }
        if model == nil {
            model = comics
        } else {
            model?.append(contentsOf: comics)
        }
        viewState.onNext(.content(comics))
    }
    
    private func handleEmptyComics() { }
    
    private func handleError(_ error: Error) {
        print(error)
    }
}
