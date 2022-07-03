//
//  ComicsViewState.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

enum ComicsViewState {
    case loading
    case content(_ content: [Comic])
    case error(_ error: Error)
}
