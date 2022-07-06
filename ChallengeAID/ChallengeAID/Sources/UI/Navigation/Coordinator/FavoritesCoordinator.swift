//
//  FavoritesCoordinator.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

import UIKit

protocol FavoritesCoordinatorType: CoordinatorType { }

class FavoritesCoordinator: FavoritesCoordinatorType {
    
    // MARK: - PUBLIC PROPERTIES
    
    var parentCoordinator: CoordinatorType?
    var children: [CoordinatorType] = []
    
    // MARK: - PRIVATE PROPERTIES
    
    private var factory: AppFactoryType
    
    // MARK: - PUBLIC PROPERTIES
    
    var navigationController: UINavigationController
    
    // MARK: LIFE CYCLE
    
    init(navigationController: UINavigationController, factory: AppFactoryType) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func start() {
        let favoritesViewController = factory.makeFavoritesViewController()
        favoritesViewController.delegate = self
        navigationController.pushViewController(favoritesViewController, animated: true)
    }
}

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func favoritesViewController(didTapComic comic: ComicModel) {
        let detailsViewController = factory.makeComicDetailsViewController(.init(comic: comic))
        detailsViewController.delegate = self
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}

extension FavoritesCoordinator: ComicDetailsViewControllerDelegate {
    func comicsDetailsViewController(didTapCharacter character: CharacterModel) {
        let characterDetailsViewController = factory.makeCharacterDetailsViewController(character)
        navigationController.pushViewController(characterDetailsViewController, animated: true)
    }
}
