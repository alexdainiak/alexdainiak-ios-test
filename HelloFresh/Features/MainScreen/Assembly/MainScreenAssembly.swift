//
//  MainScreenAssembly.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Swinject


/// Assembler of MainScreen feature with ViewModel and ViewController
public final class MainScreenAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(MainScreenViewController.self) { resolver in
            
            let recipesRepository = resolver.resolve(RecipesRepository.self)!
            
            let viewModel = MainScreenViewModelImpl(recipesRepository: recipesRepository)
            let view = MainScreenViewController(viewModel: viewModel)
            
            return view
        }
    }
    
    public init() {}
}
