//
//  CharacterDetailsViewModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

protocol CharacterDetailsViewModelType {
    func getCharacter() -> CharacterModel
    func characterHasComics() -> Bool
}

class CharacterDetailsViewModel: CharacterDetailsViewModelType {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let character: CharacterModel
    
    // MARK: - INITIALIZERS
    
    init(character: CharacterModel) {
        self.character = character
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func getCharacter() -> CharacterModel {
        return character
    }
    
    func characterHasComics() -> Bool {
        if let comics = character.comics,
           !comics.isEmpty {
            return true
        }
        return false
    }
    
    // MARK: - PRIVATE FUNCTIONS
}
