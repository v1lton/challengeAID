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
    
    // MARK: - FUNCTIONS
    
    func retrieveComics(pagination: Bool)
    func getComics() -> [Comic]?
    func saveUserComic(from index: Int)
}
