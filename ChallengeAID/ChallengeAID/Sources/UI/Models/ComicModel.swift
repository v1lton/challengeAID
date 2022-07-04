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
    var isFavorite: Bool
    
    init(id: String,
         title: String?,
         description: String?,
         imagePath: String?,
         imageExtension: String?,
         isFavorite: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.imagePath = imagePath
        self.imageExtension = imageExtension
        self.isFavorite = isFavorite
    }
}
