//
//  ComicsViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import RxSwift

class ComicsViewModel: ComicsViewModelProtocol {
    
    // MARK: - ALIASES
    
    typealias ComicsResponse = Result<ComicResponse, Error>
    
    // MARK: - PRIVATE PROPERTIES
    
    private var model: [Comic]?
    private let disposeBag = DisposeBag()
    
    // MARK: - PUBLIC PROPERTIES
    
    var viewState: BehaviorSubject<ComicsViewState> = .init(value: .loading)
    
    // MARK: - INITIALIZERS
    
    init() { }
    
    // MARK: - PRIVATE METHODS
    
    func retrieveComics() {
        let networking = NetworkingOperation()
        let request = MarvelRequest(cases: .comics)
        
        networking.request(request: request) { [weak self] (response: ComicsResponse) in
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
        model = comics
        viewState.onNext(.content(comics))
    }
    
    private func handleEmptyComics() { }
    
    private func handleError(_ error: Error) {
        print(error)
    }
}
