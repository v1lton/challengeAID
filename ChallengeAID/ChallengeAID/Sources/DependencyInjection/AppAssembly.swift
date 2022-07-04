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
        
        // MARK: - Networking
        
        container.register(NetworkingOperationProtocol.self) { _ in
            return NetworkingOperation()
        }
        
        // MARK: - Use Cases
        
        container.register(ComicsUseCaseType.self) { resolver in
            let networking = resolver.resolveUnwrapping(NetworkingOperationProtocol.self)
            return ComicsUseCase(networking: networking)
        }
        
        // MARK: Entity Managers
        
        container.register(ComicManagerProtocol.self) { _ in
            return ComicManager()
        }
        
        // MARK: - ComicsViewController
        
        container.register(ComicsViewModelProtocol.self) { resolver in
            let comicManager = resolver.resolveUnwrapping(ComicManagerProtocol.self)
            let useCase = resolver.resolveUnwrapping(ComicsUseCaseType.self)
            return ComicsViewModel(comicManager: comicManager, comicsUseCase: useCase)
        }
        
        container.register(ComicsViewController.self) { resolver in
            let viewModel = resolver.resolveUnwrapping(ComicsViewModelProtocol.self)
            return ComicsViewController(viewModel: viewModel)
        }
        
        // MARK: - DetailsViewController
        
        container.register(DetailsViewModelProtocol.self) { (_, model: DetailsModel) in
            return DetailsViewModel(model: model)
        }
        
        container.register(DetailsViewController.self) { (resolver, model: DetailsModel) in
            let viewModel = resolver.resolveUnwrapping(DetailsViewModelProtocol.self, argument: model)
            return DetailsViewController(viewModel: viewModel)
        }
    }
}
