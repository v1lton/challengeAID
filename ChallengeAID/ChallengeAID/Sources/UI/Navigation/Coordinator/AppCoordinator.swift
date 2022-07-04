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
        comicsViewController.delegate = self
        navigationController.pushViewController(comicsViewController, animated: false)
    }
}

extension AppCoordinator: ComicsViewControllerDelegate {
    func comicsViewController(didTapComic comic: ComicModel) {
        let detailsViewController = factory.makeDetailsViewController(.init(comic: comic))
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
