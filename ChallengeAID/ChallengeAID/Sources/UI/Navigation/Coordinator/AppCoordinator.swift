//
//  AppCoordinator.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var factory: ViewControllerFactoryProtocol
    
    // MARK: - PUBLIC PROPERTIES
    
    var navigationController: UINavigationController
    
    // MARK: LIFE CYCLE
    
    init(navigationController: UINavigationController, factory: ViewControllerFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func start() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makeComicsTabBarItem(),
                                            makeFavoritesTabBarItem()]
        navigationController.pushViewController(tabBarController, animated: false)
    }
    
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func makeComicsTabBarItem() -> UIViewController {
        let comicsViewController = factory.makeComicsViewController()
        comicsViewController.delegate = self
        comicsViewController.tabBarItem.title = "Comics"
        comicsViewController.tabBarItem.image = .init(systemName: "book")
        return comicsViewController
    }
    
    private func makeFavoritesTabBarItem() -> UIViewController {
        let favoritesViewController = factory.makeFavoritesViewController()
        favoritesViewController.delegate = self
        favoritesViewController.tabBarItem.title = "Favorites"
        favoritesViewController.tabBarItem.image = .init(systemName: "heart")
        return favoritesViewController
    }
}

extension AppCoordinator: ComicsViewControllerDelegate {
    func comicsViewController(didTapComic comic: ComicModel) {
        let detailsViewController = factory.makeDetailsViewController(.init(comic: comic))
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}

extension AppCoordinator: FavoritesViewControllerDelegate {
    func favoritesViewController(didTapComic comic: ComicModel) {
        let detailsViewController = factory.makeDetailsViewController(.init(comic: comic))
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
