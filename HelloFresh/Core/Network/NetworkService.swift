//
//  NetworkService.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//
import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

protocol NetworkService {
    func getRecipes(completion: @escaping (Result<[RecipeDto], AppError>) -> Void)
   
}

final class NetworkServiceImpl: NetworkService {
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func getRecipes(completion: @escaping (Result<[RecipeDto], AppError>) -> Void) {
        request(api: MainScreenTarget.getRecipes, completion: completion)
    }
}

extension NetworkServiceImpl {
    
    func request<T: Codable>(api: BaseTarget, completion: @escaping (Result<T, AppError>) -> Void) {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = api.path
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if api.conectionType == .stub {
            do {
                guard let data = api.sampleData else {
                    completion(.failure(.noData))
                    return
                }
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(responseObject))
            } catch {
                completion(.failure(.decodingError(error)))
            }
            
            return
        }
        
        let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            if let appError = AppError(data: data, response: response, error: error) {
                completion(.failure(appError))
                
                return
            }
            
            do {
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(responseObject))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        dataTask.resume()
    }
}

enum AppError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case decodingError(Error)
    case noData
}

extension AppError {
    
    init?(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            self = .transportError(error)
            return
        }
        
        if let response = response as? HTTPURLResponse,
           !(200...299).contains(response.statusCode) {
            self = .serverError(statusCode: response.statusCode)
            return
        }
        
        if data == nil {
            self = .noData
        }
        
        return nil
    }
}
