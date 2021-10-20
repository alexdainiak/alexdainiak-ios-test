//
//  MainScreenViewModel.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//
protocol MainScreenViewModel {
    var items: [Recipe] { get }
}

final class MainScreenViewModelImpl: MainScreenViewModel {
    var items: [Recipe] = []
    let recipesRepository: RecipesRepository
    
    init(recipesRepository: RecipesRepository) {
        self.recipesRepository = recipesRepository
    }
}
