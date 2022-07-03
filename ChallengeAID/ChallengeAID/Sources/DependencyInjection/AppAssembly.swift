//
//  AppAssembly.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Swinject
import UIKit

class AppAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - Factory
        
        container.register(ViewControllerFactoryProtocol.self) { resolver in
            return ViewControllerFactory(resolver: resolver)
        }
        
        // MARK: - Coordinator
        
        container.register(Coordinator.self) { (resolver, navigationController: UINavigationController) in
            let factory = resolver.resolveUnwrapping(ViewControllerFactoryProtocol.self)
            return AppCoordinator(navigationController: navigationController,
                                  factory: factory)
        }
        
        // MARK: Entity Managers
        
        container.register(ComicManagerProtocol.self) { _ in
            return ComicManager()
        }
        
        // MARK: - ComicsViewController
        
        container.register(ComicsViewModelProtocol.self) { resolver in
            let comicManager = resolver.resolveUnwrapping(ComicManagerProtocol.self)
            return ComicsViewModel(comicManager: comicManager)
        }
        
        container.register(ComicsViewController.self) { resolver in
            let viewModel = resolver.resolveUnwrapping(ComicsViewModelProtocol.self)
            return ComicsViewController(viewModel: viewModel)
        }
    }
}
