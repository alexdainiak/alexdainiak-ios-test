//
//  MainScreenDataAssembly.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Swinject

public class MainScreenDataAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(RecipesRepository.self) { _ in
 
            return RecipesRepositoryImpl(netorkService: NetworkServiceImpl())
        }
    }
}
