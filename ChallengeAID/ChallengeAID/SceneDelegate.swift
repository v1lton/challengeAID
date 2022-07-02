//
//  SceneDelegate.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - PUBLIC PROPERTIES
    
    var window: UIWindow?
    var coordinator: AppCoordinator?

    // MARK: - PUBLIC FUNCTIONS
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        makeCoordinator(with: navigationController)
        setupWindow(windowScene, for: navigationController)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func makeCoordinator(with navigationController: UINavigationController) {
        self.coordinator = AppCoordinator(navigationController: navigationController)
        self.coordinator?.start()
    }
    
    private func setupWindow(_ windowScene: UIWindowScene, for navigationController: UINavigationController) {
        window = UIWindow(frame: .zero)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        window?.windowScene = windowScene
    }
}
