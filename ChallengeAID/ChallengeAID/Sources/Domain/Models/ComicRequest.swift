//
//  ComicRequest.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import Foundation

struct ComicRequest: Codable {
    
    let title: String?
    let offset: Int?
    let limit: Int?
    
    init(title: String? = "",
         offset: Int?,
         limit: Int? = 15) {
        self.title = title
        self.offset = offset
        self.limit = limit
    }
    
    func asQueryItens() -> [URLQueryItem] {
        return [URLQueryItem(name: "limit", value: String(limit ?? 0)),
                URLQueryItem(name: "offset", value: String(offset ?? 0))]
    }
}
