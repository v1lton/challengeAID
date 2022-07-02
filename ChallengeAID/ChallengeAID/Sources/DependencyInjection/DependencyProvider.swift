//
//  DependencyProvider.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Swinject

public struct DependencyProvider {
    
    // MARK: - PUBLIC PROPERTIES
    
    static let shared = DependencyProvider()
    public let container = Container()
    
    // MARK: - PRIVATE PROPERTIES
    
    private let assembler: Assembler
    
    // MARK: - LIFE CYCLE
    
    public init() {
        assembler = Assembler([AppAssembly()], container: container)
    }
}
