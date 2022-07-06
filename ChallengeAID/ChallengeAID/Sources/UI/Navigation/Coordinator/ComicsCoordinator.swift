//
//  ComicsCoordinator.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 05/07/22.
//

import Foundation

import UIKit

protocol ComicsCoordinatorType: CoordinatorType { }

class ComicsCoordinator: ComicsCoordinatorType {
    
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
        let comicsViewController = factory.makeComicsViewController()
        comicsViewController.delegate = self
        navigationController.pushViewController(comicsViewController, animated: true)
    }
}

extension ComicsCoordinator: ComicsViewControllerDelegate {
    func comicsViewController(didTapComic comic: ComicModel) {
        let detailsViewController = factory.makeComicDetailsViewController(.init(comic: comic))
        detailsViewController.delegate = self
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}

extension ComicsCoordinator: ComicDetailsViewControllerDelegate {
    func comicsDetailsViewController(didTapCharacter character: CharacterModel) {
        let characterDetailsViewController = factory.makeCharacterDetailsViewController(character)
        navigationController.pushViewController(characterDetailsViewController, animated: true)
    }
}
