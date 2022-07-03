//
//  NetworkingOperation.swift
//  ChallengeAID
//
//  Created by Wilton Ramos da Silva on 02/07/22.
//

import Foundation

public protocol NetworkingOperationProtocol: AnyObject {
    func request<ResponseType: Codable>(request: Request, completion: @escaping(Result<ResponseType, Error>) -> ())
}

public class NetworkingOperation: NetworkingOperationProtocol {
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func request<ResponseType: Codable>(request: Request, completion: @escaping (Result<ResponseType, Error>) -> ())  {
        var compoments = URLComponents()
        compoments.scheme = request.scheme
        compoments.host = request.baseURL
        compoments.path = request.path
        compoments.queryItems = request.parameters
        
        guard let url = compoments.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.name
        print("urlRequest: \(urlRequest)")
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            
            guard error == nil else {
                completion(.failure(error!)) //TODO: fix force cast
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            guard response != nil, let data = data else { return }
            
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode(ResponseType.self, from: data) {
                    completion(.success(responseObject))
                } else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
