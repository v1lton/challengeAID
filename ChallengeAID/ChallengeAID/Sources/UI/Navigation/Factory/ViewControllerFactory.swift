//
//  ViewControllerFactory.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Swinject
import UIKit

class ViewControllerFactory: ViewControllerFactoryProtocol {
    
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
    
    public func makeDetailsViewController(_ model: DetailsModel) -> DetailsViewController {
        return resolver.resolveUnwrapping(DetailsViewController.self, argument: model)
    }
    
    public func makeFavoritesViewController() -> FavoritesViewController {
        return resolver.resolveUnwrapping(FavoritesViewController.self)
    }
}
