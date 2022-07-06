//
//  DetailsViewModelType.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

import CoreGraphics
import RxSwift

protocol ComicDetailsViewModelType {
    
    // MARK: - PROPERTIES
    
    var viewState: BehaviorSubject<ComicDetailsViewState> { get }
    
    // MARK: FUNCTIONS
    
    func getComic() -> ComicModel
    func favoriteComic()
    func unfavoriteComic()
    func getCharacters() -> [CharacterModel]?
    func getCreators() -> [ComicModel.Character]?
    func getTableViewHeight() -> CGFloat
    func retrieveCharacters()
    func getNumberOfSections() -> Int
    func getCharacter(at index: Int) -> CharacterModel?
}
