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
        
        container.register(AppFactoryType.self) { resolver in
            return AppFactory(resolver: resolver)
        }
        
        // MARK: - Coordinators
        
        container.register(Coordinator.self) { (resolver, navigationController: UINavigationController) in
            let factory = resolver.resolveUnwrapping(AppFactoryType.self)
            return AppCoordinator(navigationController: navigationController,
                                  factory: factory)
        }
        
        container.register(ComicsCoordinatorType.self) { (resolver, navigationController: UINavigationController) in
            let factory = resolver.resolveUnwrapping(AppFactoryType.self)
            return ComicsCoordinator(navigationController: navigationController,
                                     factory: factory)
        }
        
        container.register(FavoritesCoordinatorType.self) { (resolver, navigationController: UINavigationController) in
            let factory = resolver.resolveUnwrapping(AppFactoryType.self)
            return FavoritesCoordinator(navigationController: navigationController,
                                     factory: factory)
        }
        
        // MARK: - Networking
        
        container.register(NetworkingOperationType.self) { _ in
            return NetworkingOperation()
        }
        
        // MARK: Entity Managers
        
        container.register(ComicObjectManagerType.self) { _ in
            return ComicObjectManager()
        }
        
        // MARK: - Use Cases
        
        container.register(ComicsUseCaseType.self) { resolver in
            let networking = resolver.resolveUnwrapping(NetworkingOperationType.self)
            let comicObjectManager = resolver.resolveUnwrapping(ComicObjectManagerType.self)
            return ComicsUseCase(networking: networking, comicObjectManager: comicObjectManager)
        }
        
        container.register(CharactersUseCaseType.self) { resolver in
            let networking = resolver.resolveUnwrapping(NetworkingOperationType.self)
            return CharactersUseCase(networking: networking)
        }

        // MARK: - ComicsViewController
        
        container.register(ComicsViewModelProtocol.self) { resolver in
            let comicManager = resolver.resolveUnwrapping(ComicObjectManagerType.self)
            let useCase = resolver.resolveUnwrapping(ComicsUseCaseType.self)
            return ComicsViewModel(comicManager: comicManager, comicsUseCase: useCase)
        }
        
        container.register(ComicsViewController.self) { resolver in
            let viewModel = resolver.resolveUnwrapping(ComicsViewModelProtocol.self)
            return ComicsViewController(viewModel: viewModel)
        }
        
        // MARK: - DetailsViewController
        
        container.register(DetailsViewModelProtocol.self) { (resolver, model: DetailsModel) in
            let comicManager = resolver.resolveUnwrapping(ComicObjectManagerType.self)
            let charactersUseCase = resolver.resolveUnwrapping(CharactersUseCaseType.self)
            return DetailsViewModel(model: model,
                                    comicManager: comicManager,
                                    charactersUseCase: charactersUseCase)
        }
        
        container.register(DetailsViewController.self) { (resolver, model: DetailsModel) in
            let viewModel = resolver.resolveUnwrapping(DetailsViewModelProtocol.self, argument: model)
            return DetailsViewController(viewModel: viewModel)
        }
        
        // MARK: - FavoritesViewController
        
        container.register(FavoritesViewModelType.self) { resolver in
            let comicManager = resolver.resolveUnwrapping(ComicObjectManagerType.self)
            return FavoritesViewModel(comicManager: comicManager)
        }
        
        container.register(FavoritesViewController.self) { resolver in
            let viewModel = resolver.resolveUnwrapping(FavoritesViewModelType.self)
            return FavoritesViewController(viewModel: viewModel)
        }
    }
}
