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
}
