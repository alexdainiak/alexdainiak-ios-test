//
//  NetworkService.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//
import Foundation

protocol NetworkService {
    func request<T: Codable>(api: BaseTarget, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkServiceImpl: NetworkService {
     func request<T: Codable>(api: BaseTarget, completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = api.path
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard response != nil , let data = data else { return }
            
            let responseObject = try! JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(responseObject))
            }
        }
        dataTask.resume()
    }
}
