//
//  Request.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case put
    case post
    case patch
    case delete
    
    var name: String {
        return self.rawValue.uppercased()
    }
}

public protocol Request {
    
    var scheme: String { get }
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
}
