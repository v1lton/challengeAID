//
//  Coordinator.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import UIKit

protocol CoordinatorType {
    
    // MARK: - PROPERTIES
    
    var parentCoordinator: CoordinatorType? { get set }
    var children: [CoordinatorType] { get set }
    var navigationController: UINavigationController { get set }
    
    // MARK: - FUNCTIONS
    
    func start()
}
