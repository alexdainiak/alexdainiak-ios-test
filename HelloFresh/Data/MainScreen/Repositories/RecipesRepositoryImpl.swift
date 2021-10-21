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
    
    func getRecipes(completion: @escaping (Result<[RecipeDto], AppError>) -> Void) {
        netorkService.request(api: MainScreenTarget.getRecipes) { (result: Result<[RecipeDto], AppError>) in
            completion(result)
        }
    }
}
