//
//  NetworkManagerMock.swift
//  CercacorAssignmentTests
//
//  Created by Applanding Solutions on 2024-06-25.
//

import Foundation
@testable import CercacorAssignment

class NetworkManagerMock: NetworkManagerDelegate {
    
    var data: Data?
    var error: Error?
    
    func make(request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw NetworkError.statusCodeUnavailable
        }
        return (data, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
    
    func parseData<Item: Decodable>(data: Data) throws -> Item {
        return try JSONDecoder().decode(Item.self, from: data)
    }
}
