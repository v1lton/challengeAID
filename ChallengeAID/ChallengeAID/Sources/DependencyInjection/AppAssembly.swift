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
        
        // MARK: - ComicsViewController
        
        container.register(ComicsViewModelProtocol.self) { _ in
            return ComicsViewModel()
        }
        
        container.register(ComicsViewController.self) { resolver in
            let viewModel = resolver.resolveUnwrapping(ComicsViewModelProtocol.self)
            return ComicsViewController(viewModel: viewModel)
        }
    }
}
