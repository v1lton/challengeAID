//
//  ViewControllerFactory.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Swinject
import UIKit

class AppFactory: AppFactoryType {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var resolver: Resolver
    
    // MARK: - INTIALIZERS
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func makeComicsViewController() -> ComicsViewController {
        return resolver.resolveUnwrapping(ComicsViewController.self)
    }
    
    public func makeDetailsViewController(_ model: ComicDetailsModel) -> ComicDetailsViewController {
        return resolver.resolveUnwrapping(ComicDetailsViewController.self, argument: model)
    }
    
    public func makeFavoritesViewController() -> FavoritesViewController {
        return resolver.resolveUnwrapping(FavoritesViewController.self)
    }
    
    public func makeComicsCoordinator(with navigationController: UINavigationController) -> ComicsCoordinatorType {
        return resolver.resolveUnwrapping(ComicsCoordinatorType.self, argument: navigationController)
    }
    
    public func makeFavoritesCoordinator(with navigationController: UINavigationController) -> FavoritesCoordinatorType {
        return resolver.resolveUnwrapping(FavoritesCoordinatorType.self, argument: navigationController)
    }
}
