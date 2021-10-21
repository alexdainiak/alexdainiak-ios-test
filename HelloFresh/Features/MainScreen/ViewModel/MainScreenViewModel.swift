//
//  MainScreenViewModel.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//
import Foundation

protocol MainScreenViewModel {
    var items: [Recipe] { get }
    var showAlert: ((String) -> Void)? { get set }
    var updateView: (() -> Void)? { get set }
    func loadRecipes()
}

final class MainScreenViewModelImpl: MainScreenViewModel {
    
    // MARK: - Public properties
    
    var showAlert: ((String) -> Void)?
    var updateView: (() -> Void)?
    var items: [Recipe] = []
    
    // MARK: - Private properties
    
    private let recipesRepository: RecipesRepository
    
    init(recipesRepository: RecipesRepository) {
        self.recipesRepository = recipesRepository
    }
    
    // MARK: - Public methods
    
    func loadRecipes() {
        recipesRepository.getRecipes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let recipes):
                    self.items = recipes
                    
                    DispatchQueue.main.async {
                        self.updateView?()
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert?(error.localizedDescription)
                    }
            }
        }
    }
}
