//
//  Resolver+Extensions.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Swinject

extension Resolver {
    public func resolveUnwrapping<Service>(_ serviceType: Service.Type) -> Service {
        if let resolution = resolve(serviceType) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        if let resolution = resolve(serviceType, argument: argument) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }
}
