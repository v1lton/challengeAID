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
        let comicsViewController = factory.makeComicsViewController()
        navigationController.pushViewController(comicsViewController, animated: false)
    }
}
