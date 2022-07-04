//
//  EntityCellModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

struct EntityCellModel {
    
    // MARK: - PUBLIC PROPERTIES
    
    let title: String?
    let description: String?
    let imagePath: String?
    let imageExtension: String?
    
    // MARK: - INITIALIZER
    
    init(title: String?,
         description: String?,
         imagePath: String?,
         imageExtension: String?) {
        self.title = title
        self.description = description
        self.imagePath = imagePath
        self.imageExtension = imageExtension
    }
}
