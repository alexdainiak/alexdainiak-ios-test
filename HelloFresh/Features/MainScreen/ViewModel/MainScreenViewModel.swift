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
        recipesRepository.getRecipes { [weak self] (result: Result<[RecipeDto], AppError>) in
            guard let self = self else { return }
            
            switch result {
                case .success(let recipes):
                    self.items = recipes
                    self.updateView?()
                    
                case .failure(let error):
                    if case .serverError(let statusCode) = error {
                        self.showAlert?(String(statusCode).appending(" serverError code"))
                    } else if case .decodingError = error {
                        self.showAlert?("decodingError")
                    } else if case .noData = error {
                        self.showAlert?("noData")
                    } else if case .transportError = error {
                        self.showAlert?("transportError")
                    } else {
                        self.showAlert?(error.localizedDescription)
                    }
            }
        }
    }
}
