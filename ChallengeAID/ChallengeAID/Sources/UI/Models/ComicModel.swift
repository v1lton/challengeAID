//
//  ComicModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 04/07/22.
//


public struct ComicModel {
    
    let id: String
    let title: String?
    let description: String?
    let imagePath: String?
    let imageExtension: String?
    let characters: [Character]?
    let creators: [Character]?
    var isFavorite: Bool
    
    init(id: String,
         title: String?,
         description: String?,
         imagePath: String?,
         imageExtension: String?,
         characters: [Character]?,
         creators: [Character]?,
         isFavorite: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.imagePath = imagePath
        self.imageExtension = imageExtension
        self.characters = characters
        self.creators = creators
        self.isFavorite = isFavorite
    }
}

extension ComicModel {
    public struct Character {
        let resourceURI: String?
        let name: String?
        let role: String?
        
        public init(from summary: CharacterSummary) {
            self.resourceURI = summary.resourceURI
            self.name = summary.name
            self.role = summary.role
        }
        
        public init(from characterObject: CharacterManagedObject) {
            self.resourceURI = characterObject.resourceURI
            self.name = characterObject.name
            self.role = characterObject.role
        }
        
        public init(from creatorObject: CreatorManagedObject) {
            self.resourceURI = creatorObject.resourceURI
            self.name = creatorObject.name
            self.role = creatorObject.role
        }
    }
}
