//
//  RecipesRepositoryTests.swift
//  HelloFreshTests
//
//  Created by Дайняк Александр Николаевич on 21.10.2021.
//

import XCTest
@testable import HelloFresh

class RecipesRepositoryTests: XCTestCase {
    
    private var recipesRepository: RecipesRepository!
    private var networkServiceMock: NetworkServiceMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkServiceMock = NetworkServiceMock(result: RecipesRepositoryTests.resipesSuccessMock)
        recipesRepository = RecipesRepositoryImpl(netorkService: networkServiceMock)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    override func tearDown() {
        recipesRepository = nil
        networkServiceMock = nil
        super.tearDown()
    }
    
    func testSuccessfullRecipesResponce() {
        networkServiceMock = NetworkServiceMock(result: RecipesRepositoryTests.resipesSuccessMock)
        recipesRepository = RecipesRepositoryImpl(netorkService: networkServiceMock)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [Recipe]?
        
        recipesRepository.getRecipes { result in
            switch result {
            case .success(let recipesDto):
                recipes = recipesDto
                recipesExpectation.fulfill()
                
            case .failure(_):
                recipesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(recipes?.count, 1)
            XCTAssertEqual(recipes?.first?.name, "foo")
        }
    }
    
    func testErrorRecipesResponse() {
        networkServiceMock = NetworkServiceMock(result: RecipesRepositoryTests.resipesErrorMock)
        recipesRepository = RecipesRepositoryImpl(netorkService: networkServiceMock)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [Recipe]?
        var error: AppError?
        
        recipesRepository.getRecipes { result in
            switch result {
            case .success(let recipesDto):
                recipes = recipesDto
                recipesExpectation.fulfill()
                
            case .failure(let appError):
                error = appError
                recipesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNil(recipes)
            
            var statusCode = 0
            
            if case .serverError(let code) = error {
                statusCode = code
            }
            XCTAssertEqual(statusCode, 403)
        }
    }
    
    func testNoDataErrorRecipesResponse() {
        networkServiceMock = NetworkServiceMock(result: RecipesRepositoryTests.resipesNoDataErrorMock)
        recipesRepository = RecipesRepositoryImpl(netorkService: networkServiceMock)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [Recipe]?
        var error: AppError?
        
        recipesRepository.getRecipes { result in
            switch result {
            case .success(let recipesDto):
                recipes = recipesDto
                recipesExpectation.fulfill()
                
            case .failure(let appError):
                error = appError
                recipesExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNil(recipes)
            if case .noData = error {
                XCTAssertTrue(true, ".noData error type equals to expected")
            } else {
                XCTAssertTrue(false, "noData error type does not equal to expected")
            }
        }
    }
}

extension RecipesRepositoryTests {
    static var resipesSuccessMock: Result<[RecipeDto], AppError> {
        let recipes: [RecipeDto] = [
            RecipeDto(
                id: "1",
                name: "foo",
                headline: "bar",
                image: "image",
                preparationMinutes: 22
            )
        ]
        
        return Result.success(recipes)
    }
    
    static var resipesErrorMock: Result<[RecipeDto], AppError> {
        return Result.failure(AppError.serverError(statusCode: 403))
    }
    
    static var resipesNoDataErrorMock: Result<[RecipeDto], AppError> {
        return Result.failure(AppError.noData)
    }
}

