//
//  ViewControllerFactoryProtocol.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

protocol AppFactoryType {
    func makeComicsCoordinator(with navigationController: UINavigationController) -> ComicsCoordinatorType
    func makeFavoritesCoordinator(with navigationController: UINavigationController) -> FavoritesCoordinatorType
    func makeComicsViewController() -> ComicsViewController
    func makeComicDetailsViewController(_ model: ComicDetailsModel) -> ComicDetailsViewController
    func makeFavoritesViewController() -> FavoritesViewController
    func makeCharacterDetailsViewController(_ model: CharacterModel) -> CharacterDetailsViewController
}
