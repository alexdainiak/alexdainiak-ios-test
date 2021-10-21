//
//  MockUrlSession.swift
//  HelloFreshTests
//
//  Created by Дайняк Александр Николаевич on 21.10.2021.
//

import Foundation
@testable import HelloFresh

final class MockURLSession: URLSessionProtocol {
    
    var request: URLRequest?
    private let mockDataTask: MockURLSessionDataTask
    
    init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
        mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        mockDataTask.completionHandler = completionHandler
        return mockDataTask
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}
