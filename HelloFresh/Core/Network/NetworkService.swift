//
//  NetworkService.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//
import Foundation

protocol NetworkService {
    func request<T: Codable>(api: BaseTarget, completion: @escaping (Result<T, AppError>) -> Void)
}

final class NetworkServiceImpl: NetworkService {
    var sampleData: Data {
        
        guard let path = Bundle.main.path(forResource: "recipesStub", ofType: "json")  else { return Data() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return Data() }
        
        return data
    }
    
    func request<T: Codable>(api: BaseTarget, completion: @escaping (Result<T, AppError>) -> Void) {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = api.path
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        if api.conectionType == .stub {
            
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: sampleData)
                
                completion(.success(responseObject))
            } catch {
                completion(.failure(.decodingError(error)))
            }
            
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            if let appError = AppError(data: data, response: response, error: error) {
                completion(.failure(appError))
                
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data!)
                
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
