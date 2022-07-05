//
//  AppCoordinator.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

class AppCoordinator: Coordinator {
    
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
        self.navigationController.isNavigationBarHidden = true
        self.factory = factory
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    
    
    public func start() {
        let tabBarController = UITabBarController()
        
        let comicsNavigationController = makeComicsNavigationController()
        setupComicsCoordinator(with: comicsNavigationController)
        
        let favoritesNavigationController = makeFavoritesNavigationController()
        setupFavoritesCoordinator(with: favoritesNavigationController)
        
        tabBarController.viewControllers = [favoritesNavigationController, comicsNavigationController]
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func makeComicsNavigationController() -> UINavigationController {
        let comicsNavigationController = UINavigationController()
        comicsNavigationController.tabBarItem.title = "Comics"
        comicsNavigationController.tabBarItem.image = .init(systemName: "book")
        return comicsNavigationController
    }
    
    private func makeFavoritesNavigationController() -> UINavigationController {
        let favoritesNavigationController = UINavigationController()
        favoritesNavigationController.tabBarItem.title = "Favorites"
        favoritesNavigationController.tabBarItem.image = .init(systemName: "heart")
        return favoritesNavigationController
    }
    
    private func setupComicsCoordinator(with navigationController: UINavigationController) {
        let comicsCoordinator = ComicsCoordinator(navigationController: navigationController, factory: factory)
        comicsCoordinator.parentCoordinator = self
        children.append(comicsCoordinator)
        comicsCoordinator.start()
    }
    
    private func setupFavoritesCoordinator(with navigationController: UINavigationController) {
        let favoritesCoordinator = FavoritesCoordinator(navigationController: navigationController, factory: factory)
        favoritesCoordinator.parentCoordinator = self
        children.append(favoritesCoordinator)
        favoritesCoordinator.start()
    }
    
    
//    private func makeComicsTabBarItem() -> UIViewController {
//    }
//
//    private func makeFavoritesTabBarItem() -> UIViewController {
//    }
}
