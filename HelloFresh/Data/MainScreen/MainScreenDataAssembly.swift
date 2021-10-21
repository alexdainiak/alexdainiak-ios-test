//
//  MainScreenDataAssembly.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Swinject

/// Assembler of MainScreen data layer with RecipesRepository
public class MainScreenDataAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(RecipesRepository.self) { _ in
 
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
            return RecipesRepositoryImpl(netorkService: NetworkServiceImpl(urlSession: session))
        }
    }
}
