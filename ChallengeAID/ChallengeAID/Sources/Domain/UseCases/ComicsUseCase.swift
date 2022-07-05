//
//  ComicsUseCase.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 04/07/22.
//

import RxSwift

protocol ComicsUseCaseType {
    func execute(with requestModel: ComicsRequestModel) -> Observable<Result<[ComicModel]?, Error>>
}

class ComicsUseCase: ComicsUseCaseType {
    
    // MARK: - ALIASES
    
    typealias UseCaseEventType = Result<[ComicModel]?, Error>
    typealias ServiceReturningType = Result<ComicDataWrapper, Error>
    
    // MARK: - PRIVATE PROPERTIES
    
    private let comicObjectManager: ComicObjectManagerType
    private let networking: NetworkingOperationProtocol
    
    // MARK: - INITIALIZERS
    
    init(networking: NetworkingOperationProtocol, comicObjectManager: ComicObjectManagerType) {
        self.networking = networking
        self.comicObjectManager = comicObjectManager
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func execute(with requestModel: ComicsRequestModel) -> Observable<UseCaseEventType> {
        return createObservable(with: requestModel)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func createObservable(with requestModel: ComicsRequestModel) -> Observable<UseCaseEventType> {
        return .create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.makeRequest(with: requestModel, observer)
            return Disposables.create()
        }
    }
    
    private func makeRequest(with requestModel: ComicsRequestModel, _ observer: AnyObserver<UseCaseEventType>) {
        let request = MarvelRequest(cases: .comics(model: requestModel))
        networking.request(request: request) { [weak self] (result: ServiceReturningType) in
            guard let self = self else { return }
            observer.onNext(self.handleResult(result))
        }
    }
    
    private func convertComicToModel(_ comic: Comic) -> ComicModel? {
        guard let id = comic.id else { return nil }
        return ComicModel(id: String(id),
                          title: comic.title,
                          description: comic.description,
                          imagePath: comic.images?.first?.path,
                          imageExtension: comic.images?.first?.imageExtension,
                          characters: convertCharaterListToModel(comic.characters),
                          creators: convertCreatorListToModel(comic.creators),
                          isFavorite: comicObjectManager.isComicFavorite(String(id)))
    }
    
    private func convertCharaterListToModel(_ characterList: CharacterList?) -> [ComicModel.Character]? {
        return characterList?.items?.compactMap({ list in
            return .init(from: list)
        })
    }
    
    private func convertCreatorListToModel(_ creatorList: CreatorList?) -> [ComicModel.Character]? {
        return creatorList?.items?.compactMap({ list in
            return .init(from: list)
        })
    }
    
    // MARK: - HANDLERS
    
    private func handleResult(_ result: ServiceReturningType) -> UseCaseEventType {
        switch result {
        case .success(let data):
            return handleSuccess(data)
        case .failure(let error):
            return handleError(error)
        }
    }
    
    private func handleSuccess(_ data: ComicDataWrapper) -> UseCaseEventType {
        let comics = data.data?.results
        let comicObjects: [ComicModel]? = comics?.compactMap({ comic in
            return convertComicToModel(comic)
        })
        return .success(comicObjects)
    }
    
    private func handleError(_ error: Error) -> UseCaseEventType {
        return .failure(error)
    }
}
