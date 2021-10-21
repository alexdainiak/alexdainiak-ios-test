//
//  NetworkServiceTests.swift
//  HelloFreshTests
//
//  Created by Дайняк Александр Николаевич on 21.10.2021.
//
import XCTest
@testable import HelloFresh

class NetworkServiceTests: XCTestCase {
    
    private var recipesJsonData: Data!
    private var networkService: NetworkService!
    private var mockURLSession: MockURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        recipesJsonData = loadDataInJSONFile(fileName: "recipesStub")!
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    override func tearDown() {
        networkService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testSuccessfullRecipesResponse() {
        let mockURLSession = MockURLSession(data: recipesJsonData, urlResponse: nil, responseError: nil)
        networkService = NetworkServiceImpl(urlSession: mockURLSession)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [RecipeDto]?
        
        networkService.getRecipes {result in
            switch result {
            case .success(let recipesDto):
                recipes = recipesDto
                recipesExpectation.fulfill()
                
            case .failure(_):
                recipesExpectation.fulfill()
            }
        }
        
        let expectedName = "Crispy Fish Goujons"
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(recipes?.count, 3)
            XCTAssertEqual(recipes?.first?.name, expectedName)
        }
    }
    
    func testEmptyDataRecipeResponse() {
        networkService = nil
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        networkService = NetworkServiceImpl(urlSession: mockURLSession)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [RecipeDto]?
        var error: AppError?
        
        networkService.getRecipes { result in
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
    
    func testInvalidJsonResponse() {
        networkService = nil
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        networkService = NetworkServiceImpl(urlSession: mockURLSession)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [RecipeDto]?
        var error: AppError?
        
        networkService.getRecipes { result in
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
            if case .decodingError(_) = error {
                XCTAssertTrue(true, ".decodingError error type equals to expected")
            } else {
                XCTAssertTrue(false, "decodingError error type does not equal to expected")
            }
        }
    }
    
    func testTransportErrorFromResponse() {
        networkService = nil
        let nsError = NSError(domain: "Foo error", code: 401, userInfo: [:])
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nsError)
        networkService = NetworkServiceImpl(urlSession: mockURLSession)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [RecipeDto]?
        var error: AppError?
        
        networkService.getRecipes { result in
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
            if case .transportError(_) = error {
                XCTAssertTrue(true, ".transportError error type equals to expected")
            } else {
                XCTAssertTrue(false, "transportError error type does not equal to expected")
            }
        }
    }
    
    func testServiceErrorFromResponse() {
        networkService = nil
        let expectedStatusCode = 404
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: expectedStatusCode, httpVersion: nil, headerFields: [:])
        mockURLSession = MockURLSession(data: nil, urlResponse: response, responseError: nil)
        networkService = NetworkServiceImpl(urlSession: mockURLSession)
        let recipesExpectation = expectation(description: "recipesExpectation")
        var recipes: [RecipeDto]?
        var error: AppError?
        
        networkService.getRecipes { result in
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
            XCTAssertEqual(statusCode, expectedStatusCode)
        }
    }
}

extension NetworkServiceTests {
    func loadDataInJSONFile(fileName: String) -> Data? {
        let bundle = Bundle(for: NetworkServiceImpl.self)
        guard let filePath = bundle.path(forResource: fileName, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        return data
    }
}
