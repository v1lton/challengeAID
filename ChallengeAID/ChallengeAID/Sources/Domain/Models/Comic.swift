//
//  Comic.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Foundation

public struct ComicDataWrapper: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: ComicDataContainer?
    let etag: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case status
        case copyright
        case attributionText
        case attributionHTML
        case data
        case etag
    }
}

public struct ComicDataContainer: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Comic]?
    
    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}

public struct Comic: Codable {
    let id: Int?
    let digitalId: Int?
    let title: String?
    let images: [Image]?
    let characters: CharacterList?
    let description: String?
    let creators: CreatorList?
}

public struct Image: Codable {
    let path: String?
    let imageExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}

public struct CreatorList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [CharacterSummary]?
}

public struct CharacterList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [CharacterSummary]?
}

public struct CharacterSummary: Codable {
    let resourceURI: String?
    let name: String?
    let role: String?
}
