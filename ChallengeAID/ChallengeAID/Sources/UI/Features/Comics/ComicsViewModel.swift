//
//  ComicsViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import RxSwift
import CoreData

class ComicsViewModel: ComicsViewModelProtocol {
    
    // MARK: - ALIASES
    
    typealias ComicsResponse = Result<ComicResponse, Error>
    
    // MARK: - PRIVATE PROPERTIES
    
    private let comicManager: ComicManagerProtocol
    private var model: [Comic]?
    private let disposeBag = DisposeBag()
    
    // MARK: - PUBLIC PROPERTIES
    
    var viewState: BehaviorSubject<ComicsViewState> = .init(value: .loading)
    var isPaginating: Bool = false
    
    // MARK: - INITIALIZERS
    
    init(comicManager: ComicManagerProtocol) {
        self.comicManager = comicManager
    }
    
    // MARK: - PUBLIC METHODS
    
    func getComics() -> [Comic]? {
        return model
    }
    
    func saveUserComic(from index: Int) {
        guard let comic = model?[index] else { return }
        comicManager.create(comic)
    }
    
    // MARK: - PRIVATE METHODS
    //TODO: fix marks
    func retrieveComics(pagination: Bool) {
        if pagination {
            isPaginating = true
        }
        let networking = NetworkingOperation()
        let offset = !pagination ? 0 : (model?.count ?? 0 + 1)
        let request = MarvelRequest(cases: .comics(model: .init(offset: offset)))
        
        networking.request(request: request) { [weak self] (response: ComicsResponse) in
            self?.isPaginating = false
            self?.handleRetrieveComics(response)
        }
    }
    
    // MARK: - HANDLERS
    
    private func handleRetrieveComics(_ response: ComicsResponse) {
        switch response {
        case .success(let response):
            handleSuccess(response.data?.results)
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func handleSuccess(_ comics: [Comic]?) {
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
