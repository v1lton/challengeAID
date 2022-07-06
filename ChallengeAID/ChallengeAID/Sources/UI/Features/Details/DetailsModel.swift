//
//  DetailsModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import Foundation

struct DetailsModel {
    let comic: ComicModel
    var characters: [CharacterModel]?
    
    init(comic: ComicModel,
         characters: [CharacterModel]? = nil) {
        self.comic = comic
        self.characters = characters
    }
    
    func getCharactersIds() -> [String]? {
        var ids = [String]()
        guard let characters = comic.characters else {
            return nil
        }
        for character in characters {
            if let uri = character.resourceURI {
                ids.append(uri.deletingPrefix("http://gateway.marvel.com/v1/public/characters/"))
            }
        }
        return ids
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
