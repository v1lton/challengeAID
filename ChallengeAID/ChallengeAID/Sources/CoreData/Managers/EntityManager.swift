//
//  EntityManager.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 03/07/22.
//

import CoreData
import UIKit

public protocol EntityManagerProtocol {
    var coreDataContext: NSManagedObjectContext { get }
}

open class EntityManager: EntityManagerProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    public var coreDataContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("")
        }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
}
