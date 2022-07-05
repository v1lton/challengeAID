//
//  DetailsUseCase.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

import RxSwift

protocol DetailsUseCaseType {
    func execute(with ids: [String]) -> Observable<Result<[CharacterModel], Error>>
}

class DetailsUseCase: DetailsUseCaseType {
    
    // MARK: - ALIASES
    
    typealias UseCaseEventType = Result<[CharacterModel], Error>
    typealias ServiceReturningType = Result<[CharacterDataWrapper], Error>
    
    // MARK: - PRIVATE PROPERTIES
    
    private let networking: NetworkingOperationProtocol
    
    // MARK: - INITIALIZERS
    
    init(networking: NetworkingOperationProtocol) {
        self.networking = networking
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func execute(with ids: [String]) -> Observable<UseCaseEventType> {
        return createObservable(with: ids)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func createObservable(with ids: [String]) -> Observable<UseCaseEventType> {
        return .create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.makeRequests(with: ids, observer)
            return Disposables.create()
        }
    }
    
    private func makeRequests(with ids: [String], _ observer: AnyObserver<UseCaseEventType>) {
        let requests = ids.compactMap { id in
            return MarvelRequest(cases: .characters(characterId: id))
        }
        networking.request(requests: requests) { [weak self] (result: ServiceReturningType) in
            guard let self = self else { return }
            observer.onNext(self.handleResult(result))
        }
    }
    
    private func convertComicsToArrayString(_ comics: [ComicSummary]?) -> [String]? {
        return comics?.compactMap { summary in
            return summary.name
        }
    }
    
    private func convertDataWrapperToCharacters(_ data: [CharacterDataWrapper]) -> [Character] {
        return data.compactMap { dataWrapper in
            return dataWrapper.data?.results?.first
        }
    }
    
    private func convertCharactersToModel(_ characters: [Character]) -> [CharacterModel] {
        characters.compactMap { character in
            return .init(name: character.name,
                         description: character.description,
                         imagePath: character.thumbnail?.path,
                         imageExtension: character.thumbnail?.thumbnailExtension,
                         comics: convertComicsToArrayString(character.comics?.items))
        }
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
    
    private func handleSuccess(_ data: [CharacterDataWrapper]) -> UseCaseEventType {
        let characters = convertDataWrapperToCharacters(data)
        let characterObjects = convertCharactersToModel(characters)
        return .success(characterObjects)
    }
    
    private func handleError(_ error: Error) -> UseCaseEventType {
        return .failure(error)
    }
}
