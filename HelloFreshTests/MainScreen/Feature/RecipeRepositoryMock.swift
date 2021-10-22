//
//  RecipeRepositoryMock.swift
//  HelloFreshTests
//
//  Created by Дайняк Александр Николаевич on 21.10.2021.
//

@testable import HelloFresh

class RecipeRepositoryMock: RecipesRepository {

    let result: Result<[Recipe], AppError>
    
    init(result: Result<[Recipe], AppError>) {
        self.result = result
    }
    
    func getRecipes(completion: @escaping (Result<[Recipe], AppError>) -> Void) {
        completion(result)
    }
}

