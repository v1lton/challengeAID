//
//  AppCoordinator.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - PUBLIC PROPERTIES
    
    var navigationController: UINavigationController
    
    // MARK: LIFE CYCLE
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func start() {
        let homeViewController = HomeViewController()
        navigationController.pushViewController(homeViewController, animated: false)
    }
}
