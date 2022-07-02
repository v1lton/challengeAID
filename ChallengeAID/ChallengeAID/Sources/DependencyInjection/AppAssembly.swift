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
        
        container.register(ViewControllerFactoryProtocol.self) { resolver in
            return ViewControllerFactory(resolver: resolver)
        }
        
        container.register(Coordinator.self) { (resolver, navigationController: UINavigationController) in
            let factory = resolver.resolveUnwrapping(ViewControllerFactoryProtocol.self)
            return AppCoordinator(navigationController: navigationController,
                                  factory: factory)
        }
        
        container.register(HomeViewController.self) { _ in
            return HomeViewController()
        }
    }
}
