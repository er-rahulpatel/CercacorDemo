//
//  NetworkManager.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-20.
//

import Foundation

protocol NetworkManagerDelegate {
    func make(request: URLRequest) async throws -> (Data, URLResponse)
    func parseData<Item: Decodable>(data: Data) throws-> Item
}

class NetworkManager: NetworkManagerDelegate {
    static let shared = NetworkManager()
    let urlSession: URLSession
    
    private init() {
        self.urlSession = URLSession.shared
    }
    ///Common method to make a request to server
    func make(request: URLRequest) async throws -> (Data, URLResponse) {
        let response: (Data, URLResponse) = try await self.urlSession.data(for: request)
        guard let urlResponse = response.1 as? HTTPURLResponse else{
            throw NetworkError.statusCodeUnavailable
        }
        if let error = ResponseError.getErrorType(for:urlResponse.statusCode){
            throw NetworkError.APIError(error)
        }
        return response
        
    }
    
    ///Try to parse retrived data
    func parseData<Item: Decodable>(data: Data) throws-> Item {
        return try JSONDecoder().decode(Item.self, from: data)
    }
    
}


