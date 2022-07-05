//
//  FavoritesCoordinator.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

import UIKit

protocol FavoritesCoordinatorType: Coordinator { }

class FavoritesCoordinator: FavoritesCoordinatorType {
    
    // MARK: - PUBLIC PROPERTIES
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    
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
        let detailsViewController = factory.makeDetailsViewController(.init(comic: comic))
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
