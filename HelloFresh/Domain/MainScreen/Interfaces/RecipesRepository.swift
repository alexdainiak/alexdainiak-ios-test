//
//  RecipesRepository.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Foundation


protocol RecipesRepository {
    func getRecipes(completion: @escaping (Result<[Recipe], AppError>) -> Void)
}
 
