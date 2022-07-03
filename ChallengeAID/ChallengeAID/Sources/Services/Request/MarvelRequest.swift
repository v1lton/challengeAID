//
//  MarvelRequest.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Foundation

struct MarvelRequest: Request {
    
    // MARK: - CASES
    
    enum Req {
        case comics
        case characters
    }
    
    let cases: Req
    
    // MARK: - REQUEST PROTOCOL
    
    var scheme: String {
        switch cases {
        default:
            return "https"
        }
    }
    
    var method: HTTPMethod {
        switch cases {
        case .comics,
             .characters:
            return .get
        }
    }
    
    var baseURL: String {
        switch cases {
        default:
            return "gateway.marvel.com"
        }
    }
    
    var path: String {
        switch cases {
        case .comics:
            return "/v1/public/comics"
        case .characters:
            return "/v1/public/characters"
        }
    }
    
    var parameters: [URLQueryItem] {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let privateKey = "aaf4426bbc98f90b7b2b774b4ddbae7a8df819a8"
        let apiKey = "7a7ed695471a3977d4f5baa70de8a112"
        let hash = "\(timestamp)\(privateKey)\(apiKey)".md5
        
        switch cases {
        case .comics:
            return [URLQueryItem(name: "ts", value: timestamp),
                    URLQueryItem(name: "hash", value: hash),
                    URLQueryItem(name: "apikey", value: apiKey),
                    URLQueryItem(name: "limit", value: "20")]
        case .characters:
            return [URLQueryItem(name: "ts", value: timestamp),
                    URLQueryItem(name: "hash", value: hash),
                    URLQueryItem(name: "apikey", value: apiKey)]
        }
    }
}
