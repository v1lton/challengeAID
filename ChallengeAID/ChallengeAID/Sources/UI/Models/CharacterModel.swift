//
//  CharacterModel.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

public struct CharacterModel {
    let name: String?
    let description: String?
    let imagePath: String?
    let imageExtension: String?
    let comics: [String]?
    
    func getImageUrl() -> String {
        guard let imagePath = imagePath,
              let imageExtension = imageExtension else {
            return ""
        }
        return "\(imagePath)/landscape_incredible.\(imageExtension)"
    }
}
