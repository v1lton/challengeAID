//
//  ComicsViewModelProtocol.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import RxSwift

protocol ComicsViewModelProtocol {
    
    // MARK: - PROPERTIES
    
    var viewState: BehaviorSubject<ComicsViewState> { get }
    
    // MARK: - FUNCTIONS
    
    func retrieveComics()
    func getComics() -> [Comic]?
    func saveUserComic(from index: Int)
}
