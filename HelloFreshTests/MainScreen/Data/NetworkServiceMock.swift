//
//  NetworkServiceMock.swift
//  HelloFreshTests
//
//  Created by Дайняк Александр Николаевич on 21.10.2021.
//

@testable import HelloFresh

class NetworkServiceMock: NetworkService {

    let result: Result<[RecipeDto], AppError>
    
    init(result: Result<[RecipeDto], AppError>) {
        self.result = result
    }
    
    func getRecipes(completion: @escaping (Result<[RecipeDto], AppError>) -> Void) {
        
        completion(result)
    }
}

