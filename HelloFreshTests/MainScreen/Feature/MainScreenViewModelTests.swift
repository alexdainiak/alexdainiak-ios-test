//
//  MainScreenViewModelTests.swift
//  HelloFreshTests
//
//  Created by Дайняк Александр Николаевич on 21.10.2021.
//

import XCTest
@testable import HelloFresh

class MainScreenViewModelTests: XCTestCase {
    private var mainScreenViewModel: MainScreenViewModel!
    private var recipesRepositoryMock: RecipeRepositoryMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    override func tearDown() {
        mainScreenViewModel = nil
        super.tearDown()
    }
    
    func testSuccessfullRecipesResponce() {
        let recipesRepositoryMock = RecipeRepositoryMock(result: MainScreenViewModelTests.resipesSuccessMock)
        mainScreenViewModel = MainScreenViewModelImpl(recipesRepository: recipesRepositoryMock)
        var didCallShowAlert = false
        mainScreenViewModel.showAlert = { _ in
            didCallShowAlert = true
        }
        
        var didCallUpdateView = false
        mainScreenViewModel.updateView = {
            didCallUpdateView = true
        }
        
        let recipesExpectation = expectation(description: "recipesExpectation")
        recipesExpectation.fulfill()
        mainScreenViewModel.loadRecipes()
        
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.mainScreenViewModel.items.count, 1)
            XCTAssertEqual(self.mainScreenViewModel.items.first?.name, "foo")
            XCTAssertTrue(didCallUpdateView, "Did not call viewModel.updateView")
            XCTAssertFalse(didCallShowAlert, "Did call viewModel.showAlert")
        }
    }
    
    func testErrorResponce() {
        let recipesRepositoryMock = RecipeRepositoryMock(result: MainScreenViewModelTests.resipesErrorMock)
        mainScreenViewModel = MainScreenViewModelImpl(recipesRepository: recipesRepositoryMock)
        var didCallShowAlert = false
        mainScreenViewModel.showAlert = { _ in
            didCallShowAlert = true
        }
        
        var didCallUpdateView = false
        mainScreenViewModel.updateView = {
            didCallUpdateView = true
        }
        
        let recipesExpectation = expectation(description: "recipesExpectation")
        recipesExpectation.fulfill()
        mainScreenViewModel.loadRecipes()
        
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mainScreenViewModel.items.isEmpty)
            XCTAssertFalse(didCallUpdateView, "Did call viewModel.updateView")
            XCTAssertTrue(didCallShowAlert, "Did not call viewModel.showAlert")
        }
    }
    
    func testNoDataResponce() {
        let recipesRepositoryMock = RecipeRepositoryMock(result: MainScreenViewModelTests.resipesNoDataErrorMock)
        mainScreenViewModel = MainScreenViewModelImpl(recipesRepository: recipesRepositoryMock)
        var didCallShowAlert = false
        mainScreenViewModel.showAlert = { _ in
            didCallShowAlert = true
        }
        
        var didCallUpdateView = false
        mainScreenViewModel.updateView = {
            didCallUpdateView = true
        }
        
        let recipesExpectation = expectation(description: "recipesExpectation")
        recipesExpectation.fulfill()
        mainScreenViewModel.loadRecipes()
        
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mainScreenViewModel.items.isEmpty)
            XCTAssertFalse(didCallUpdateView, "Did call viewModel.updateView")
            XCTAssertTrue(didCallShowAlert, "Did not call viewModel.showAlert")
        }
    }
}

extension MainScreenViewModelTests {
    static var resipesSuccessMock: Result<[Recipe], AppError> {
        let recipes: [Recipe] = [
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
    
    static var resipesErrorMock: Result<[Recipe], AppError> {
        return Result.failure(AppError.serverError(statusCode: 403))
    }
    
    static var resipesNoDataErrorMock: Result<[Recipe], AppError> {
        return Result.failure(AppError.noData)
    }
}
