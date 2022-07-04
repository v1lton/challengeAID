//
//  ViewControllerFactoryProtocol.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

protocol ViewControllerFactoryProtocol {
    func makeComicsViewController() -> ComicsViewController
    func makeDetailsViewController(_ model: DetailsModel) -> DetailsViewController
    func makeFavoritesViewController() -> FavoritesViewController
}
