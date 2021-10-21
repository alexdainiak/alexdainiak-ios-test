//
//  ApplicationCoordinatorAssembly.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Swinject

final public class ApplicationCoordinatorAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(ApplicationCoordinator.self) { (resolver, assembler: Assembler, navigationController: UINavigationController) in
            
            let applicationCoordinator = ApplicationCoordinator(assembler: assembler)
            
            applicationCoordinator.mainScreenCoordinator = assembler.resolver.resolve(MainScreenCoordinator.self, argument: navigationController)!
            return applicationCoordinator
        }
    }
}
