//
//  ComicsViewModelProtocol.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import RxSwift

protocol ComicsViewModelProtocol {
    
    // MARK: - PROPERTIES
    
    var isPaginating: Bool { get set }
    var viewState: BehaviorSubject<ComicsViewState> { get }
    var filterModel: FilterSearchModel? { get set }
    
    // MARK: - FUNCTIONS
    
    func retrieveComics(pagination: Bool)
    func getComics() -> [ComicModel]?
    func getComic(at index: Int) -> ComicModel?
    func favoriteComic(from index: Int)
}
