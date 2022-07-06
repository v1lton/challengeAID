//
//  ComicsViewState.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

enum ComicsViewState {
    case loading(asPagination: Bool)
    case success(asPagination: Bool)
    case error(_ error: Error)
}
