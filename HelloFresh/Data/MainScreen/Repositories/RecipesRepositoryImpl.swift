//
//  RecipesRepositoryImpl.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Foundation

final class RecipesRepositoryImpl: RecipesRepository {
    
    let netorkService: NetworkService
    init(netorkService: NetworkService) {
        self.netorkService = netorkService
    }
    
    func getRecipes(completion: @escaping (Result<[Recipe], AppError>) -> Void) {
        netorkService.getRecipes { (result: Result<[RecipeDto], AppError>) in
            completion(result.map { $0 })
        }
    }
}
